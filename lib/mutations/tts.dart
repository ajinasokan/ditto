import 'package:ditto/app.dart';

FlutterTts flutterTts = FlutterTts();

class InitTTS extends Mutation<OlamStore> {
  exec() async {
    final langs = await flutterTts.getLanguages;

    if (langs != null) {
      store.ttsLanguages.clear();
      store.ttsLanguages = {"Default": "default"};
      langs.forEach((lang) {
        if (lang.toString().toLowerCase().startsWith("en")) {
          var name = lang.toString().substring(3);
          if (name == "US") name = "United States";
          if (name == "GB") name = "United Kingdom";
          if (name == "AU") name = "Australia";
          if (name == "IN") name = "India";
          if (name == "IE") name = "Ireland";
          if (name == "ZA") name = "South Africa";
          store.ttsLanguages[name] = lang.toString();
        }
      });
    }
  }
}

class Speak extends Mutation<OlamStore> {
  exec() async {
    if (store.selectedTTSLanguage != "Default") {
      await flutterTts
          .setLanguage(store.ttsLanguages[store.selectedTTSLanguage]);
    }
    flutterTts.speak(store.selectedEntry.word);
  }
}

class SetTTSLanguage extends Mutation<OlamStore> {
  String lang;

  SetTTSLanguage(this.lang);

  void exec() async {
    store.selectedTTSLanguage = lang;
    later(() => SaveStore());
  }
}
