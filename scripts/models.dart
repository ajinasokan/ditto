import 'dart:convert';
import 'dart:typed_data';

class Entry {
  String word;
  String info;
  List<Definition> definitions;

  Map toMap() {
    return {
      "word": word,
      "info": info,
      "definitions": definitions.map((d) => d.toMap()).toList(),
    };
  }

  List<int> toBytes() {
    List<int> defBytes = [];
    definitions.forEach((def) {
      defBytes.addAll(def.toBytes());
    });
    var wordBytes = utf8.encode(word);
    var infoBytes = utf8.encode(info);
    return []
      ..addAll(intToBytes(
          wordBytes.length + infoBytes.length + defBytes.length + 12))
      ..addAll(intToBytes(wordBytes.length))
      ..addAll(wordBytes)
      ..addAll(intToBytes(infoBytes.length))
      ..addAll(infoBytes)
      ..addAll(intToBytes(definitions.length))
      ..addAll(defBytes);
  }

  void fromBytes(List<int> bytes, [int offset = 0]) {
    offset += 4;
    var wordLen = bytesToInt(bytes.sublist(offset, offset + 4));
    offset += 4;
    word = utf8.decode(bytes.sublist(offset, offset + wordLen));
    offset += wordLen;
    var infoLen = bytesToInt(bytes.sublist(offset, offset + 4));
    offset += 4;
    info = utf8.decode(bytes.sublist(offset, offset + infoLen));
    offset += infoLen;

    definitions = [];
    var defLen = bytesToInt(bytes.sublist(offset, offset + 4));
    offset += 4;
    for (int i = 0; i < defLen; i++) {
      var def = Definition();
      offset = def.fromBytes(bytes, offset);
      definitions.add(def);
    }
  }
}

class Definition {
  String definition;
  String partOfSpeech;

  Map toMap() {
    return {
      "definition": definition,
      "partOfSpeech": partOfSpeech,
    };
  }

  List<int> toBytes() {
    var defBytes = utf8.encode(definition);
    var posByts = utf8.encode(partOfSpeech);
    return []
      ..addAll(intToBytes(defBytes.length))
      ..addAll(defBytes)
      ..addAll(intToBytes(posByts.length))
      ..addAll(posByts);
  }

  int fromBytes(List<int> bytes, [int offset = 0]) {
    var defLen = bytesToInt(bytes.sublist(offset, offset + 4));
    offset += 4;
    definition = utf8.decode(bytes.sublist(offset, offset + defLen));
    offset += defLen;
    var posLen = bytesToInt(bytes.sublist(offset, offset + 4));
    offset += 4;
    partOfSpeech = utf8.decode(bytes.sublist(offset, offset + posLen));
    offset += posLen;
    return offset;
  }
}

List<int> intToBytes(int val) {
  return (ByteData(4)..setUint32(0, val)).buffer.asInt8List();
}

int bytesToInt(List<int> bytes) {
  Int8List list = new Int8List.fromList(bytes);
  return ByteData.view(list.buffer).getInt32(0);
}
