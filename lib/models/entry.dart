import 'dart:convert';
import 'definition.dart';

@pragma("model")
class Entry {
  @pragma('json:database_id')
  int databaseId;

  @pragma('json:word')
  String word = "";

  @pragma('json:info')
  String info = "";

  @pragma('json:definitions')
  List<Definition> definitions = [];

  Entry({
    this.databaseId,
    this.word,
    this.info,
    this.definitions,
  }) {
    init();
  }

  void init() {
    if (word == null) word = "";
    if (info == null) info = "";
    if (definitions == null) definitions = [];
  }

  void patch(Map _data) {
    if (_data == null) return null;
    databaseId = _data["database_id"];
    word = _data["word"];
    info = _data["info"];
    definitions = (_data["definitions"] ?? [])
        .map((i) => Definition.fromMap(i))
        .toList()
        .cast<Definition>();
    init();
  }

  factory Entry.fromMap(Map data) {
    if (data == null) return null;
    return Entry()..patch(data);
  }

  Map<String, dynamic> toMap() => {
        "database_id": databaseId,
        "word": word,
        "info": info,
        "definitions": definitions?.map((i) => i.toMap())?.toList(),
      };
  String toJson() => json.encode(toMap());
  Map<String, dynamic> serialize() => {
        "databaseId": databaseId,
        "word": word,
        "info": info,
        "definitions": definitions.map((dynamic i) => i?.serialize()).toList(),
      };

  factory Entry.clone(Entry from) => Entry(
        databaseId: from.databaseId,
        word: from.word,
        info: from.info,
        definitions: from.definitions,
      );

  factory Entry.fromJson(String data) => Entry.fromMap(json.decode(data));
}
