import 'dart:convert';

@pragma('model')
class Word {
  String word;
  int offset;
  int definitionCount;

  Word({
    this.word,
    this.offset,
    this.definitionCount,
  });

  void patch(Map _data) {
    if (_data == null) return null;
  }

  factory Word.fromMap(Map data) {
    if (data == null) return null;
    return Word()..patch(data);
  }

  Map<String, dynamic> toMap() => {};
  String toJson() => json.encode(toMap());
  Map<String, dynamic> serialize() => {
        'word': word,
        'offset': offset,
        'definitionCount': definitionCount,
      };

  factory Word.clone(Word from) => Word(
        word: from.word,
        offset: from.offset,
        definitionCount: from.definitionCount,
      );

  factory Word.fromJson(String data) => Word.fromMap(json.decode(data));
}
