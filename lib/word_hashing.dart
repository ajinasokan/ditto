String hashMalayalam(String input) => MLPhone.instance.encode(input);

String hashKannada(String input) => KNPhone.instance.encode(input);

class MLPhone {
  static final instance = MLPhone();

  final vowels = <String, String>{
    "അ": "A",
    "ആ": "A",
    "ഇ": "I",
    "ഈ": "I",
    "ഉ": "U",
    "ഊ": "U",
    "ഋ": "R",
    "എ": "E",
    "ഏ": "E",
    "ഐ": "AI",
    "ഒ": "O",
    "ഓ": "O",
    "ഔ": "O"
  };

  final consonants = <String, String>{
    "ക": "K",
    "ഖ": "K",
    "ഗ": "K",
    "ഘ": "K",
    "ങ": "NG",
    "ച": "C",
    "ഛ": "C",
    "ജ": "J",
    "ഝ": "J",
    "ഞ": "NJ",
    "ട": "T",
    "ഠ": "T",
    "ഡ": "T",
    "ഢ": "T",
    "ണ": "N1",
    "ത": "0",
    "ഥ": "0",
    "ദ": "0",
    "ധ": "0",
    "ന": "N",
    "പ": "P",
    "ഫ": "F",
    "ബ": "B",
    "ഭ": "B",
    "മ": "M",
    "യ": "Y",
    "ര": "R",
    "ല": "L",
    "വ": "V",
    "ശ": "S1",
    "ഷ": "S1",
    "സ": "S",
    "ഹ": "H",
    "ള": "L1",
    "ഴ": "Z",
    "റ": "R1"
  };

  final chillus = <String, String>{
    "ൽ": "L",
    "ൾ": "L1",
    "ൺ": "N1",
    "ൻ": "N",
    "ർ": "R1",
    "ൿ": "K"
  };

  final compounds = <String, String>{
    "ക്ക": "K2",
    "ഗ്ഗ": "K",
    "ങ്ങ": "NG",
    "ച്ച": "C2",
    "ജ്ജ": "J",
    "ഞ്ഞ": "NJ",
    "ട്ട": "T2",
    "ണ്ണ": "N2",
    "ത്ത": "0",
    "ദ്ദ": "D",
    "ദ്ധ": "D",
    "ന്ന": "NN",
    "ന്ത": "N0",
    "ങ്ക": "NK",
    "ണ്ട": "N1T",
    "ബ്ബ": "B",
    "പ്പ": "P2",
    "മ്മ": "M2",
    "യ്യ": "Y",
    "ല്ല": "L2",
    "വ്വ": "V",
    "ശ്ശ": "S1",
    "സ്സ": "S",
    "ള്ള": "L12",
    "ഞ്ച": "NC",
    "ക്ഷ": "KS1",
    "മ്പ": "MP",
    "റ്റ": "T",
    "ന്റ": "NT",
    "ന്ത": "N0",
    "്രി": "R",
    "്രു": "R",
  };

  final modifiers = <String, String>{
    "ാ": "",
    "ഃ": "",
    "്": "",
    "ൃ": "R",
    "ം": "3",
    "ി": "4",
    "ീ": "4",
    "ു": "5",
    "ൂ": "5",
    "െ": "6",
    "േ": "6",
    "ൈ": "7",
    "ൊ": "8",
    "ോ": "8",
    "ൌ": "9",
    "ൗ": "9"
  };

  final regexKey0 = RegExp(r'[1,2,4-9]');
  final regexKey1 = RegExp(r'[2,4-9]');
  final regexNonMalayalam = RegExp(r'[^\u0D00-\u0D7F]');
  final regexAlphaNum = RegExp(r'[^0-9A-Z]');
  RegExp modCompounds;
  RegExp modConsonants;
  RegExp modVowels;

  MLPhone() {
    List<String> mods = modifiers.keys.toList();

    List<String> glyphs = compounds.keys.toList();
    modCompounds =
        RegExp('((' + glyphs.join("|") + ')(' + mods.join('|') + '))');

    glyphs = consonants.keys.toList();
    modConsonants =
        RegExp('((' + glyphs.join("|") + ')(' + mods.join('|') + '))');

    glyphs = vowels.keys.toList();
    modVowels = RegExp('((' + glyphs.join("|") + ')(' + mods.join('|') + '))');
  }

  String encode(String input) {
    input = _process(input);
    // input = input.replaceAll(regexKey1, "");
    // input = input.replaceAll(regexKey0, "");
    return input;
  }

  String _process(String input) {
    input = input.trim().replaceAll(regexNonMalayalam, "");
    input = _replaceModifiedGlyphs(input, compounds, modCompounds);
    compounds.forEach((key, value) {
      input = input.replaceAll(key, '{' + value + '}');
    });
    input = _replaceModifiedGlyphs(input, consonants, modConsonants);
    input = _replaceModifiedGlyphs(input, vowels, modVowels);
    consonants.forEach((key, value) {
      input = input.replaceAll(key, '{' + value + '}');
    });
    vowels.forEach((key, value) {
      input = input.replaceAll(key, '{' + value + '}');
    });
    chillus.forEach((key, value) {
      input = input.replaceAll(key, '{' + value + '}');
    });
    modifiers.forEach((key, value) {
      input = input.replaceAll(key, '{' + value + '}');
    });
    input = input.replaceAll(regexAlphaNum, "");
    input =
        input.replaceAll(RegExp(r'^(A|V|T|S|U|M|O)L(K|S)'), '\1' + '0' + '\2');
    return input;
  }

  String _replaceModifiedGlyphs(
      String input, Map<String, String> glyphs, RegExp r) {
    r.allMatches(input).forEach((m) {
      for (var i = 0; i < m.groupCount; i++) {
        if (glyphs.containsKey(m.group(i))) {
          input = input.replaceAll(m.group(i), glyphs[m.group(i)]);
        }
      }
    });
    return input;
  }
}

// Port of https://github.com/knadh/knphone/blob/master/knphone.go
class KNPhone {
  static final instance = KNPhone();

  final vowels = <String, String>{
    "ಅ": "A",
    "ಆ": "A",
    "ಇ": "I",
    "ಈ": "I",
    "ಉ": "U",
    "ಊ": "U",
    "ಋ": "R",
    "ಎ": "E",
    "ಏ": "E",
    "ಐ": "AI",
    "ಒ": "O",
    "ಓ": "O",
    "ಔ": "O",
  };

  final consonants = <String, String>{
    "ಕ": "K",
    "ಖ": "K",
    "ಗ": "K",
    "ಘ": "K",
    "ಙ": "NG",
    "ಚ": "C",
    "ಛ": "C",
    "ಜ": "J",
    "ಝ": "J",
    "ಞ": "NJ",
    "ಟ": "T",
    "ಠ": "T",
    "ಡ": "T",
    "ಢ": "T",
    "ಣ": "N1",
    "ತ": "0",
    "ಥ": "0",
    "ದ": "0",
    "ಧ": "0",
    "ನ": "N",
    "ಪ": "P",
    "ಫ": "F",
    "ಬ": "B",
    "ಭ": "B",
    "ಮ": "M",
    "ಯ": "Y",
    "ರ": "R",
    "ಲ": "L",
    "ವ": "V",
    "ಶ": "S1",
    "ಷ": "S1",
    "ಸ": "S",
    "ಹ": "H",
    "ಳ": "L1",
    "ೞ": "Z",
    "ಱ": "R1",
  };

  final compounds = <String, String>{
    "ಕ್ಕ": "K2",
    "ಗ್ಗಾ": "K",
    "ಙ್ಙ": "NG",
    "ಚ್ಚ": "C2",
    "ಜ್ಜ": "J",
    "ಞ್ಞ": "NJ",
    "ಟ್ಟ": "T2",
    "ಣ್ಣ": "N2",
    "ತ್ತ": "0",
    "ದ್ದ": "D",
    "ದ್ಧ": "D",
    "ನ್ನ": "NN",
    "ಬ್ಬ": "B",
    "ಪ್ಪ": "P2",
    "ಮ್ಮ": "M2",
    "ಯ್ಯ": "Y",
    "ಲ್ಲ": "L2",
    "ವ್ವ": "V",
    "ಶ್ಶ": "S1",
    "ಸ್ಸ": "S",
    "ಳ್ಳ": "L12",
    "ಕ್ಷ": "KS1",
  };

  final modifiers = <String, String>{
    "ಾ": "",
    "ಃ": "",
    "್": "",
    "ೃ": "R",
    "ಂ": "3",
    "ಿ": "4",
    "ೀ": "4",
    "ು": "5",
    "ೂ": "5",
    "ೆ": "6",
    "ೇ": "6",
    "ೈ": "7",
    "ೊ": "8",
    "ೋ": "8",
    "ೌ": "9",
    "ൗ": "9",
  };

  final regexKey0 = RegExp(r'[1,2,4-9]');
  final regexKey1 = RegExp(r'[2,4-9]');
  final regexNonKannada = RegExp(r'[\P{Kannada}]');
  final regexAlphaNum = RegExp(r'[^0-9A-Z]');
  RegExp modCompounds;
  RegExp modConsonants;
  RegExp modVowels;

  KNPhone() {
    List<String> mods = modifiers.keys.toList();

    List<String> glyphs = compounds.keys.toList();
    modCompounds =
        RegExp('((' + glyphs.join("|") + ')(' + mods.join('|') + '))');

    glyphs = consonants.keys.toList();
    modConsonants =
        RegExp('((' + glyphs.join("|") + ')(' + mods.join('|') + '))');

    glyphs = vowels.keys.toList();
    modVowels = RegExp('((' + glyphs.join("|") + ')(' + mods.join('|') + '))');
  }

  String encode(String input) {
    input = _process(input);
    // input = input.replaceAll(regexKey1, "");
    input = input.replaceAll(regexKey0, "");
    return input;
  }

  String _process(String input) {
    input = input.trim().replaceAll(regexNonKannada, "");
    input = _replaceModifiedGlyphs(input, compounds, modCompounds);
    compounds.forEach((key, value) {
      input = input.replaceAll(key, '{' + value + '}');
    });
    input = _replaceModifiedGlyphs(input, consonants, modConsonants);
    input = _replaceModifiedGlyphs(input, vowels, modVowels);
    consonants.forEach((key, value) {
      input = input.replaceAll(key, '{' + value + '}');
    });
    vowels.forEach((key, value) {
      input = input.replaceAll(key, '{' + value + '}');
    });
    modifiers.forEach((key, value) {
      input = input.replaceAll(key, '{' + value + '}');
    });
    input = input.replaceAll(regexAlphaNum, "");
    return input;
  }

  String _replaceModifiedGlyphs(
      String input, Map<String, String> glyphs, RegExp r) {
    r.allMatches(input).forEach((m) {
      for (var i = 0; i < m.groupCount; i++) {
        if (glyphs.containsKey(m.group(i))) {
          input = input.replaceAll(m.group(i), glyphs[m.group(i)]);
        }
      }
    });
    return input;
  }
}
