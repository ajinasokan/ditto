import 'package:store_keeper/store_keeper.dart';
import 'package:ditto/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LoadStore extends Mutation<OlamStore> {
  Future<void> exec() async {
    var prefs = await SharedPreferences.getInstance();
    var json = prefs.getString("store");
    if (json != null) {
      store.patchWith(OlamStore.fromJson(json));
    }
    store.storeLoaded = true;
  }
}

class SaveStore extends Mutation<OlamStore> {
  exec() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("store", store.toJson());
  }
}
