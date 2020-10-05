import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';

import '../app.dart';
import '../utils.dart';

class Settings extends StatelessWidget {
  const Settings();

  final about =
      """This app is built on top of [Olam](https://olam.in/) the open source English-Malayalam, Malayalam-Malayalam dictionary.
      \nApp made with ❤ by [Ajin Asokan](https://ajinasokan.com).
      """;

  Widget header(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0, left: 16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withAlpha(50))),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    StoreKeeper.listen(context, to: [
      LoadStore,
      ToggleNightMode,
      ToggleEasyPaste,
      SetTTSLanguage,
      InitTTS,
    ]);
    var store = (StoreKeeper.store as OlamStore);
    return Container(
      child: ListView(
        children: <Widget>[
          header(context, "Addons"),
          ListTile(
            leading: Icon(FeatherIcons.moon),
            title: Text("Night mode"),
            subtitle: Text("Switches to darker colors"),
            trailing: CupertinoSwitch(
              activeColor: Theme.of(context).accentColor,
              value: store.nightMode,
              onChanged: (newVal) {
                ToggleNightMode(newVal);
              },
            ),
          ),
          ListTile(
            leading: Icon(FeatherIcons.clipboard),
            title: Text("Easy paste"),
            subtitle: Text("Search with copied text"),
            trailing: CupertinoSwitch(
              activeColor: Theme.of(context).accentColor,
              value: store.easyPaste,
              onChanged: (newVal) {
                ToggleEasyPaste(newVal);
              },
            ),
          ),
          ListTile(
            leading: Icon(FeatherIcons.radio),
            title: Text("Text to speech"),
            subtitle: Text("Locale: ${store.selectedTTSLanguage}"),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Available locales in device',
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: Theme.of(context).textTheme.bodyText2.color,
                          ),
                    ),
                    titlePadding: EdgeInsets.only(
                      top: 32,
                      left: 32,
                      right: 32,
                      bottom: 16,
                    ),
                    contentPadding: EdgeInsets.only(bottom: 16),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: store.ttsLanguages.keys.map((lang) {
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 32,
                          ),
                          title: Text(lang),
                          onTap: () {
                            SetTTSLanguage(lang);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
          Container(height: 16),
          header(context, "Privacy"),
          ListTile(
            title: Text("Clear recent searches"),
            onTap: () async {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text('Do you want to clear recent searches?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Clear'),
                        onPressed: () {
                          ClearRecent();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text("Clear bookmarks"),
            onTap: () async {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text('Do you want to clear recent bookmarks?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Clear'),
                        onPressed: () {
                          ClearBookmarks();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Container(height: 16),
          header(context, "About"),
          Container(
            padding: EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2,
                children: md2map(about).map((map) {
                  if (map["type"] == "link")
                    return TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(map["link"]);
                        },
                      text: map["value"],
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.blue),
                    );
                  else
                    return TextSpan(
                      text: map["value"],
                      style: Theme.of(context).textTheme.bodyText2,
                    );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
