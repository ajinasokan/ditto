import 'dart:typed_data';

import 'package:ditto/app.dart';
import 'package:flutter/services.dart' show rootBundle;

class LoadWords extends Mutation<OlamStore> {
  final BuildContext context;

  LoadWords(this.context);

  exec() async {
    var assetDir = "";
    var dir = await getTemporaryDirectory();

    var allFiles = await dir.parent.list(recursive: true).toList();

    for (var file in allFiles) {
      if (file is File && file.path.contains("words.bin")) {
        assetDir = file.parent.path;
        break;
      }
    }

    // print(assetDir);

    var data = assetDir == ""
        ? await DefaultAssetBundle.of(context).loadString("assets/words.bin")
        : File(assetDir + "/words.bin").readAsStringSync();

    store.words.clear();
    store.words.addAll(data.split("\n"));

    // data = assetDir == ""
    //     ? await DefaultAssetBundle.of(context).loadString("assets/words.bin")
    //     : File(assetDir + "/words.bin").readAsStringSync();
    // DefaultAssetBundle.of(context);
    // store.datukWords.clear();
    // store.datukWords.addAll(data.split("\n"));
  }
}

class FetchMeaning extends Mutation<OlamStore> {
  final Word selectedWord;

  FetchMeaning(this.selectedWord);

  void exec() async {
    ByteData buffer = await rootBundle.load("assets/defs.bin");
    int packLen = buffer.getUint32(selectedWord.offset);

    Uint8List bytes = Uint8List.view(
      buffer.buffer,
      selectedWord.offset,
      4 + packLen,
    );

    int offset = 0;
    offset += 4;
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

  void exec() {
    store.query = query;
    store.searchResults.clear();

    query = stem(query);
    if (query.trim() == "") return;

    int min = 0;
    int max = totalLength;
    int mid;
    while (min < max) {
      mid = min + ((max - min) >> 1);
      int comp = stem(getWordAt(mid, store).word).compareTo(query);
      if (comp == 0) break;
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    if (stem(getWordAt(mid, store).word).compareTo(query) == 0) {
    } else if (mid - 1 >= 0 &&
        stem(getWordAt(mid - 1, store).word).startsWith(query)) {
      mid = mid - 1;
    } else if (mid + 1 < totalLength &&
        stem(getWordAt(mid + 1, store).word).startsWith(query)) {
      mid = mid + 1;
    }

    var endIndex = mid + 10 < totalLength ? mid + 10 : totalLength;
    for (int i = mid; i < endIndex; i++) {
      var word = getWordAt(i, store);
      if (stem(word.word).contains(query)) {
        store.searchResults.add(word);
      }
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
