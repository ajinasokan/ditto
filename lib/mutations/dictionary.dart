import 'dart:typed_data';

import 'package:ditto/app.dart';
import 'package:flutter_raw_assets/flutter_raw_assets.dart';
import 'package:dart_phonetics/dart_phonetics.dart';

class LoadWords extends Mutation<OlamStore> {
  final BuildContext context;

  LoadWords(this.context);

  exec() async {
    var data =
        await DefaultAssetBundle.of(context).loadString("assets/words.bin");
    store.words.clear();
    store.words.addAll(data.split("\n"));

    data = await DefaultAssetBundle.of(context).loadString("assets/hashes.bin");
    store.hashes.clear();
    store.hashes.addAll(data.split("\n"));
  }
}

class FetchMeaning extends Mutation<OlamStore> {
  final Word selectedWord;

  FetchMeaning(this.selectedWord);

  void exec() async {
    // find length of the block
    final packLenBytes = await FlutterRawAssets.getBytes(
        "assets/defs.bin", selectedWord.offset, 4);

    int packLen = packLenBytes.buffer.asByteData().getInt32(0);

    // read the whole block
    final buffer = await FlutterRawAssets.getBytes(
        "assets/defs.bin", selectedWord.offset + 4, packLen);

    Uint8List bytes = Uint8List.view(buffer.buffer, 0, packLen);
    int offset = 0;
    var wordLen = bytesToInt(bytes.sublist(offset, offset + 4));
    offset += 4;
    var word = utf8.decode(bytes.sublist(offset, offset + wordLen));
    offset += wordLen;
    var infoLen = bytesToInt(bytes.sublist(offset, offset + 4));
    offset += 4;
    var info = utf8.decode(bytes.sublist(offset, offset + infoLen));
    offset += infoLen;

    List<Definition> definitions = [];
    var defLen = bytesToInt(bytes.sublist(offset, offset + 4));
    offset += 4;
    for (int i = 0; i < defLen; i++) {
      var defLen = bytesToInt(bytes.sublist(offset, offset + 4));
      offset += 4;
      var definition = utf8.decode(bytes.sublist(offset, offset + defLen));
      offset += defLen;
      var posLen = bytesToInt(bytes.sublist(offset, offset + 4));
      offset += 4;
      var partOfSpeech = utf8.decode(bytes.sublist(offset, offset + posLen));
      offset += posLen;

      definitions.add(Definition(
        definition: definition,
        partOfSpeech: partOfSpeech,
      ));
    }

    var entry = Entry(
      word: word,
      info: info,
      definitions: definitions,
    );

    later(() => SetMeaning(entry));
    later(() => AddToRecent(entry));
  }

  int bytesToInt(List<int> bytes) {
    Int8List list = new Int8List.fromList(bytes);
    return ByteData.view(list.buffer).getInt32(0);
  }
}

class SearchWord extends Mutation<OlamStore> {
  String query;

  SearchWord(this.query);

  static Word getWordAt(int index, OlamStore store) {
    var entry = store.words[index].split("\t");
    return Word(
      word: entry[1],
      offset: int.parse(entry[0]),
      definitionCount: int.parse(entry[2]),
    );
  }

  int get totalLength => store.words.length;

  static int binarySearch(
      String Function(int) itemGetter, int count, String value) {
    var min = 0;
    var max = count;
    while (min < max) {
      var mid = min + ((max - min) >> 1);
      var element = itemGetter(mid);
      var comp = element.compareTo(value);
      if (comp == 0) return mid;
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return -1;
  }

  static int approxBinarySearch(
      String Function(int) itemGetter, int count, String item) {
    int min = 0;
    int max = count;
    int mid;
    while (min < max) {
      mid = min + ((max - min) >> 1);
      int comp = itemGetter(mid).compareTo(item);
      if (comp == 0) break;
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }

    // backtrack to the first occurance of the item
    while (mid - 1 >= 0 && itemGetter(mid - 1).startsWith(item)) {
      mid = mid - 1;
    }

    return mid;
  }

  void exec() {
    store.query = query;
    store.searchResults.clear();

    // 0. lower case query
    // 1. search for exact match with binarySearch.
    //    if match found then add that and next 10 items to search results.
    // 2. else build hash of query
    //   2.1 if query is in english do DoubleMetaphone
    //       if in malayalam do mlphone
    //       if in kannada do knphone
    //   2.2 do approxBinarySearch on hashes.
    //       check index of the result in the word list.
    //       add word and next 10 items to results.

    // NOOP if query is blank
    if (query.trim() == "") return;

    query = query.toLowerCase();

    // exact match search
    int mid = binarySearch(
      (i) => store.words[i].split("\t")[1].toLowerCase(),
      store.words.length,
      query.toLowerCase(),
    );
    if (mid != -1) {
      var endIndex = mid + 30 < totalLength ? mid + 30 : totalLength;
      for (int i = mid; i < endIndex; i++) {
        var word = getWordAt(i, store);
        store.searchResults.add(word);
      }
      return;
    }

    final isKannada = (String input) =>
        input.codeUnitAt(0) >= 3200 && input.codeUnitAt(0) <= 3327;
    final isMalayalam = (String input) =>
        input.codeUnitAt(0) >= 3328 && input.codeUnitAt(0) <= 3455;

    if (isKannada(query)) {
      query = KNPhone.instance.encode(query);
    } else if (isMalayalam(query)) {
      query = MLPhone.instance.encode(query);
    } else {
      query = DoubleMetaphone.withMaxLength(12).encode(query)?.primary ?? "";
    }

    // problem is multiple words result in same hash
    // when binary searched hash might be found at end of the list
    // of similar hashes
    mid = approxBinarySearch(
      (i) => store.hashes[i].split("\t")[0],
      store.hashes.length,
      query,
    );

    var endIndex = mid + 30 < totalLength ? mid + 30 : totalLength;
    for (int i = mid; i < endIndex; i++) {
      // print(store.hashes[i].split("\t")[0]);
      // print(int.parse(store.hashes[i].split("\t")[1]));
      var word = getWordAt(int.parse(store.hashes[i].split("\t")[1]), store);
      store.searchResults.add(word);
    }
  }
}

class SetMeaning extends Mutation<OlamStore> {
  final Entry entry;

  SetMeaning(this.entry);

  void exec() {
    store.selectedEntry = entry;
  }
}
