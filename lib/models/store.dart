import 'package:store_keeper/store_keeper.dart' show Store;
import 'dart:convert';
import 'entry.dart';
import 'word.dart';

@pragma("model", "patchWith")
class OlamStore extends Store {
  bool storeLoaded = false;

  String query = "";
  List<Word> searchResults = [];

  @pragma('json:recent')
  List<Entry> recent = [];

  @pragma('json:bookmarks')
  List<Entry> bookmarks = [];

  @pragma('json:night_mode')
  bool nightMode = false;

  @pragma('json:easy_paste')
  bool easyPaste = false;

  @pragma('json:clipped_string')
  String clippedString = "";

  List<String> olamWords = [];

  List<String> datukWords = [];

  Entry selectedEntry = Entry();

  @pragma('json:selected_tts')
  String selectedTTSLanguage = "Default";

  @pragma('json:tts_langs')
  Map<String, dynamic> ttsLanguages = {"Default": "default"};

  OlamStore({
    this.storeLoaded,
    this.query,
    this.searchResults,
    this.recent,
    this.bookmarks,
    this.nightMode,
    this.easyPaste,
    this.clippedString,
    this.olamWords,
    this.datukWords,
    this.selectedEntry,
    this.selectedTTSLanguage,
    this.ttsLanguages,
  }) {
    init();
  }

  void init() {
    if (storeLoaded == null) storeLoaded = false;
    if (query == null) query = "";
    if (searchResults == null) searchResults = [];
    if (recent == null) recent = [];
    if (bookmarks == null) bookmarks = [];
    if (nightMode == null) nightMode = false;
    if (easyPaste == null) easyPaste = false;
    if (clippedString == null) clippedString = "";
    if (olamWords == null) olamWords = [];
    if (datukWords == null) datukWords = [];
    if (selectedEntry == null) selectedEntry = Entry();
    if (selectedTTSLanguage == null) selectedTTSLanguage = "Default";
    if (ttsLanguages == null) ttsLanguages = {"Default": "default"};
  }

  void patch(Map _data) {
    if (_data == null) return null;
    recent = (_data["recent"] ?? [])
        .map((i) => Entry.fromMap(i))
        .toList()
        .cast<Entry>();
    bookmarks = (_data["bookmarks"] ?? [])
        .map((i) => Entry.fromMap(i))
        .toList()
        .cast<Entry>();
    nightMode = _data["night_mode"];
    easyPaste = _data["easy_paste"];
    clippedString = _data["clipped_string"];
    selectedTTSLanguage = _data["selected_tts"];
    ttsLanguages = _data["tts_langs"];
    init();
  }

  factory OlamStore.fromMap(Map data) {
    if (data == null) return null;
    return OlamStore()..patch(data);
  }

  Map<String, dynamic> toMap() => {
        "recent": recent?.map((i) => i.toMap())?.toList(),
        "bookmarks": bookmarks?.map((i) => i.toMap())?.toList(),
        "night_mode": nightMode,
        "easy_paste": easyPaste,
        "clipped_string": clippedString,
        "selected_tts": selectedTTSLanguage,
        "tts_langs": ttsLanguages,
      };
  String toJson() => json.encode(toMap());
  Map<String, dynamic> serialize() => {
        "storeLoaded": storeLoaded,
        "query": query,
        "searchResults":
            searchResults.map((dynamic i) => i?.serialize()).toList(),
        "recent": recent.map((dynamic i) => i?.serialize()).toList(),
        "bookmarks": bookmarks.map((dynamic i) => i?.serialize()).toList(),
        "nightMode": nightMode,
        "easyPaste": easyPaste,
        "clippedString": clippedString,
        "olamWords": olamWords,
        "datukWords": datukWords,
        "selectedEntry": selectedEntry?.serialize(),
        "selectedTTSLanguage": selectedTTSLanguage,
        "ttsLanguages": ttsLanguages,
      };

  void patchWith(OlamStore clone) {
    storeLoaded = clone.storeLoaded;
    query = clone.query;
    searchResults = clone.searchResults;
    recent = clone.recent;
    bookmarks = clone.bookmarks;
    nightMode = clone.nightMode;
    easyPaste = clone.easyPaste;
    clippedString = clone.clippedString;
    olamWords = clone.olamWords;
    datukWords = clone.datukWords;
    selectedEntry = clone.selectedEntry;
    selectedTTSLanguage = clone.selectedTTSLanguage;
    ttsLanguages = clone.ttsLanguages;
  }

  factory OlamStore.clone(OlamStore from) => OlamStore(
        storeLoaded: from.storeLoaded,
        query: from.query,
        searchResults: from.searchResults,
        recent: from.recent,
        bookmarks: from.bookmarks,
        nightMode: from.nightMode,
        easyPaste: from.easyPaste,
        clippedString: from.clippedString,
        olamWords: from.olamWords,
        datukWords: from.datukWords,
        selectedEntry: from.selectedEntry,
        selectedTTSLanguage: from.selectedTTSLanguage,
        ttsLanguages: from.ttsLanguages,
      );

  factory OlamStore.fromJson(String data) =>
      OlamStore.fromMap(json.decode(data));
}
