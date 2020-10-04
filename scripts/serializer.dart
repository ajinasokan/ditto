import 'dart:convert';
import 'dart:io';

import 'models.dart';
import 'utils.dart';

void serialize(List<Entry> words, String defFile, String indexFile) async {
  List<List<dynamic>> offsets = [];

  int offset = 0;
  List<int> buffer = [];

  words.forEach((word) {
    offsets.add([offset, word.word, word.definitions.length]);
    var wordBytes = word.toBytes();
    buffer.addAll(wordBytes);
    offset += wordBytes.length;
  });

  log("serialized", buffer.length);

  var f = await File(defFile).create(recursive: true);
  f.writeAsBytesSync(buffer, flush: true);

  List<int> indexBuffer = [];
  for (int i = 0; i < offsets.length; i++) {
    var item = offsets[i];
    if (i == offsets.length - 1)
      indexBuffer.addAll(utf8.encode(item.join("\t")));
    else
      indexBuffer.addAll(utf8.encode(item.join("\t") + "\n"));
  }

  var w = File(indexFile);
  w.writeAsBytesSync(indexBuffer, flush: true);
}

List<List<String>> deserializeWords(String indexFile) {
  var index = File(indexFile).readAsStringSync();
  var items = index.split("\n");
  List<List<String>> offsets = [];
  items.forEach((item) {
    offsets.add(item.split("\t"));
  });
  return offsets;
}

Entry deserializeEntry(String defFile, int offset) {
  var buff = File(defFile).readAsBytesSync();
  var e = Entry();
  e.fromBytes(buff, offset);
  return e;
}
