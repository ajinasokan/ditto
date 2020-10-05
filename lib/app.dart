import 'package:ditto/models/index.dart';
import 'package:flutter/material.dart';
import 'package:store_keeper/store_keeper.dart';

export 'dart:async';
export 'dart:convert';
export 'dart:io';

export 'package:ditto/components/index.dart';
export 'package:ditto/models/index.dart';
export 'package:ditto/mutations/index.dart';
export 'package:ditto/screens/index.dart';
export 'package:feather_icons_flutter/feather_icons_flutter.dart';
export 'package:flutter/cupertino.dart' show CupertinoPageRoute;
export 'package:flutter/material.dart';
export 'package:flutter_tts/flutter_tts.dart';
export 'package:path_provider/path_provider.dart';
export 'package:store_keeper/store_keeper.dart';

export 'utils.dart';

var extraFontSize = 0.0;
var fontFamily = "NotoSans";

TextTheme textTheme(bool dark) => TextTheme(
      // app title
      headline6: TextStyle(
        fontSize: 32.0 + extraFontSize,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      ),
      subtitle2: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 14.0 + extraFontSize,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      ),
      // list title sub text, bottom navigation text
      bodyText2: TextStyle(
        fontSize: 14.0 + extraFontSize,
        fontFamily: fontFamily,
      ),
      bodyText1: TextStyle(
        fontSize: 14.0 + extraFontSize,
        letterSpacing: 1.03,
        height: 1.2,
        fontFamily: fontFamily,
      ),
      // list tile main text, text fields text, text field hint
      subtitle1: TextStyle(
        fontSize: 16.0 + extraFontSize,
        fontFamily: fontFamily,
      ),
      caption: TextStyle(
        color: dark ? Colors.grey.shade200 : Colors.grey.shade700,
        fontSize: 14.0 + extraFontSize,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      ),
    );

var darkTheme = ThemeData.dark().copyWith(
  toggleableActiveColor: Colors.blue,
  accentColor: Colors.blueAccent,
  textTheme: textTheme(true),
);

var lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColorBrightness: Brightness.light,
  primaryColor: Colors.black,
  textTheme: textTheme(false),
);

mixin StoreAccess<T extends StatefulWidget> on State<T> {
  OlamStore get store => StoreKeeper.store;
}
