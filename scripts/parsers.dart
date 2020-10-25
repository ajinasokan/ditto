import 'dart:io';
import 'models.dart';
import 'utils.dart';
import 'package:csv/csv.dart';
import 'package:yaml/yaml.dart';

List<Entry> parseAlar() {
  log("alar", "loading");
  var corpus = File("alar.yaml").readAsStringSync();
  log("alar", "parsing");

  YamlList entries = loadYaml(corpus);

  List<Entry> words = [];
  entries.forEach((entry) {
    var alarEntry = Entry();
    alarEntry.word = entry["entry"];
    alarEntry.info = entry["info"];
    alarEntry.definitions = [];
    for (int i = 0; i < entry["defs"].length; i++) {
      var def = Definition();
      def.partOfSpeech = entry["defs"][i]["type"];
      def.definition = entry["defs"][i]["entry"];
      alarEntry.definitions.add(def);
    }
    words.add(alarEntry);
  });
  log("alar count", words.length);
  return words;
}

List<Entry> parseDatuk() {
  log("datuk", "loading");
  var corpus = File("datuk.yaml").readAsStringSync();
  log("datuk", "parsing");

  YamlList entries = loadYaml(corpus);

  List<Entry> words = [];
  entries.forEach((entry) {
    var datukEntry = Entry();
    datukEntry.word = entry["entry"];
    datukEntry.info = entry["info"];
    datukEntry.definitions = [];
    for (int i = 0; i < entry["defs"].length; i++) {
      var def = Definition();
      def.partOfSpeech = entry["defs"][i]["type"];
      def.definition = entry["defs"][i]["entry"];
      datukEntry.definitions.add(def);
    }
    words.add(datukEntry);
  });
  log("datuk count", words.length);
  return words;
}

List<Entry> parseOlam() {
  log("csv", "loading");
  String csv = File("olam.csv").readAsStringSync();
  log("csv", "parsing");
  List<List<dynamic>> items = const CsvToListConverter().convert(
    csv,
    fieldDelimiter: "	",
  );
  log("count", items.length);

  log("dict", "building structures");
  Map<String, Entry> map = {};
  List<Entry> words = [];
  for (int i = 1; i < items.length; i++) {
    String itemWord = items[i][1].toString();
    String itemPOS = items[i][2].toString();
    String itemDef = items[i][3].toString();

    Entry word;
    if (map.containsKey(itemWord)) {
      word = map[itemWord];
    } else {
      word = Entry();
      word.definitions = [];
      word.info = "";
      words.add(word);
      map[itemWord] = word;
    }

    word.word = itemWord;
    var def = Definition();
    def.partOfSpeech = itemPOS;
    def.definition = itemDef;
    word.definitions.add(def);
  }
  log("olam count", words.length);
  return words;
}
