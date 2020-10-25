abstract class Flavour {
  String get title;
  String get searchHint;
  String get searchTab;
  String get bookmarkTab;
  String get wordIndexTab;
  String get settingsTab;
  String get about;
}

class OlamFlavour extends Flavour {
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
}

class AlarFlavour extends Flavour {
  @override
  String get bookmarkTab => "[bookmarks]";

  @override
  String get about =>
      """This app is built on top of [Alar](https://alar.ink) V. Krishna's Kannada → English dictionary.
      \nApp made with ❤ by [Ajin Asokan](https://ajinasokan.com).
      """;

  @override
  String get searchHint => "[search kannada word]";

  @override
  String get searchTab => "[search]";

  @override
  String get settingsTab => "[settings]";

  @override
  String get title => "ಅಲರ್";

  @override
  String get wordIndexTab => "[index]";
}
