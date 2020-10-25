import 'package:ditto/app.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_keeper/store_keeper.dart';

class Meaning extends StatefulWidget {
  const Meaning();

  @override
  MeaningState createState() {
    return MeaningState();
  }
}

class MeaningState extends State<Meaning> {
  @override
  Widget build(BuildContext context) {
    StoreKeeper.listen(context, to: [
      SetMeaning,
      AddToBookmarks,
      RemoveFromBookmarks,
    ]);
    var store = (StoreKeeper.store as OlamStore);
    List<Widget> items = [
      Visibility(
        child: header(store),
        visible:
            store.selectedEntry.word.startsWith(new RegExp(r'[\.A-Za-z0-9]')),
      ),
      Container(height: 16.0),
    ];

    Map<String, List<Widget>> meaning = {};
    store.selectedEntry.definitions.forEach((def) {
      if (meaning[def.partOfSpeech] == null) meaning[def.partOfSpeech] = [];
      meaning[def.partOfSpeech].add(Container(height: 8.0));
      meaning[def.partOfSpeech].add(listItem(def.definition));
    });
    (meaning.keys.toList()).forEach((pos) {
      items.add(Container(height: 16.0));
      items.add(itemHeader(pos));
      items.add(Column(
        mainAxisSize: MainAxisSize.min,
        children: meaning[pos],
      ));
    });

    int bookmarkIndex =
        store.bookmarks.indexWhere((e) => e.word == store.selectedEntry.word);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          store.selectedEntry.word,
          style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                bookmarkIndex != -1 ? Icons.bookmark : Icons.bookmark_border,
              ),
              onPressed: () {
                Scaffold.of(context).removeCurrentSnackBar();
                if (bookmarkIndex != -1) {
                  RemoveFromBookmarks(bookmarkIndex);
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Removed from bookmarks")));
                } else {
                  AddToBookmarks(store.selectedEntry);
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Added to bookmarks")));
                }
              },
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withAlpha(20),
                    offset: Offset(0.0, 2.0),
                    blurRadius: 3.0,
                    spreadRadius: 0.0,
                  )
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: <Widget>[
          Container(width: 8.0),
          Icon(
            FeatherIcons.circle,
            size: 10.0,
          ),
          Container(width: 8.0),
          Expanded(
            child: Builder(
              builder: (ctx) => InkWell(
                onTap: () {
                  Clipboard.setData(new ClipboardData(text: text));
                  Scaffold.of(ctx).showSnackBar(
                      SnackBar(content: Text('Text copied to clipboard')));
                },
                child: SelectableText(
                  text,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: 16.0,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemHeader(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).textTheme.caption.color.withAlpha(30),
            width: 0.5,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: 12),
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 16.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget header(OlamStore store) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () async {
            Speak();
          },
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(FeatherIcons.radio, size: 20),
                Container(width: 8.0),
                Text(
                  "Listen ",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  "(Locale: ${store.selectedTTSLanguage})",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
