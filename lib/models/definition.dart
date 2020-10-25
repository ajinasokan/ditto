import 'dart:convert';

@pragma("model")
class Definition {
  @pragma('json:definition')
  String definition = "";

  @pragma('json:part_of_speech')
  String partOfSpeech = "";

  Definition({
    this.definition,
    this.partOfSpeech,
  }) {
    init();
  }

  void init() {
    if (definition == null) definition = "";
    if (partOfSpeech == null) partOfSpeech = "";
  }

  void patch(Map _data) {
    if (_data == null) return null;
    definition = _data['definition'];
    partOfSpeech = _data['part_of_speech'];
    init();
  }

  factory Definition.fromMap(Map data) {
    if (data == null) return null;
    return Definition()..patch(data);
  }

  Map<String, dynamic> toMap() => {
        'definition': definition,
        'part_of_speech': partOfSpeech,
      };
  String toJson() => json.encode(toMap());
  Map<String, dynamic> serialize() => {
        'definition': definition,
        'partOfSpeech': partOfSpeech,
      };

  factory Definition.clone(Definition from) => Definition(
        definition: from.definition,
        partOfSpeech: from.partOfSpeech,
      );

  factory Definition.fromJson(String data) =>
      Definition.fromMap(json.decode(data));
}
