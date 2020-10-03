import 'dart:convert';
import 'entry.dart';

@pragma("model")
class Database {
  @pragma('json:entries')
  List<Entry> entries;

  Database({
    this.entries,
  });

  void patch(Map _data) {
    if (_data == null) return null;
    entries = (_data["entries"] ?? [])
        .map((i) => Entry.fromMap(i))
        .toList()
        .cast<Entry>();
  }

  factory Database.fromMap(Map data) {
    if (data == null) return null;
    return Database()..patch(data);
  }

  Map<String, dynamic> toMap() => {
        "entries": entries?.map((i) => i.toMap())?.toList(),
      };
  String toJson() => json.encode(toMap());
  Map<String, dynamic> serialize() => {
        "entries": entries.map((dynamic i) => i?.serialize()).toList(),
      };

  factory Database.clone(Database from) => Database(
        entries: from.entries,
      );

  factory Database.fromJson(String data) => Database.fromMap(json.decode(data));
}
