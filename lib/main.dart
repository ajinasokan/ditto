import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDisplayMode();
  runApp(
    StoreKeeper(
      store: OlamStore(),
      child: OlamApp(),
    ),
  );
}

void initDisplayMode() async {
  if (Platform.isAndroid) {
    try {
      var modes = await FlutterDisplayMode.supported;
      modes.sort((a, b) => (a.height * a.width * a.refreshRate)
          .compareTo(b.height * b.width * b.refreshRate));
      await FlutterDisplayMode.setMode(modes.last);
    } catch (e) {}
  }
}

class OlamApp extends StatefulWidget {
  @override
  OlamAppState createState() {
    return OlamAppState();
  }
}

class OlamAppState extends State<OlamApp> {
  @override
  void initState() {
    super.initState();
    LoadStore();
    Future.delayed(Duration(seconds: 1), () => InitTTS());
  }

  @override
  Widget build(BuildContext context) {
    StoreKeeper.listen(context, to: [
      LoadStore,
      ToggleNightMode,
    ]);

    OlamStore store = StoreKeeper.store;

    var theme;
    if (store.nightMode) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      );
      theme = darkTheme;
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      );
      theme = lightTheme;
    }

    return NotifyOn(
      mutations: {
        LoadStore: (context, __) => LoadWords(context),
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Olam',
        theme: theme,
        home: Splash(),
      ),
    );
  }
}
