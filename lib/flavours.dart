import 'package:ditto/word_hashing.dart';

abstract class Flavour {
  String get name;
  String get title;
  String get searchHint;
  String get searchTab;
  String get bookmarkTab;
  String get wordIndexTab;
  String get settingsTab;
  String get about;
  String hashWord(String input);
}

class OlamFlavour extends Flavour {
  @override
  String get name => "olam";

  @override
  String get bookmarkTab => "ശേഖരം";

  @override
  String get about =>
      """This app is built on top of [Olam](https://olam.in/) the open source English-Malayalam, Malayalam-Malayalam dictionary.
      \nApp made with ❤ by [Ajin Asokan](https://ajinasokan.com).
      """;

  @override
  String get searchHint => "english word / മലയാള പദം";

  @override
  String get searchTab => "തിരയുക";

  @override
  String get settingsTab => "സെറ്റിങ്സ്";

  @override
  String get title => "ഓളം";

  @override
  String get wordIndexTab => "പദമാലിക";

  String hashWord(String input) => hashMalayalam(input);
}

class AlarFlavour extends Flavour {
  @override
  String get name => "alar";

  @override
  String get bookmarkTab => "ಸಂಗ್ರಹ";

  @override
  String get about =>
      """This app is built on top of [Alar](https://alar.ink), V. Krishna's Kannada → English dictionary.
      \nApp made with ❤ by [Ajin Asokan](https://ajinasokan.com).
      """;

  @override
  String get searchHint => "ಕನ್ನಡ ಪದ";

  @override
  String get searchTab => "ಹುಡುಕು";

  @override
  String get settingsTab => "ಸೆಟ್ಟಿಂಗ್ಸ್";

  @override
  String get title => "ಅಲರ್";

  @override
  String get wordIndexTab => "ಸೂಚಿ";

  String hashWord(String input) => hashKannada(input);
}
