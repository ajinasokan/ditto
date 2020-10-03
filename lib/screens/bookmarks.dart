import 'package:flutter/material.dart';
import 'package:store_keeper/store_keeper.dart';

import 'package:ditto/app.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks();

  @override
  BookmarksState createState() {
    return BookmarksState();
  }
}

class BookmarksState extends State<Bookmarks> {
  @override
  Widget build(BuildContext context) {
    StoreKeeper.listen(context, to: [
      AddToBookmarks,
      RemoveFromBookmarks,
    ]);
    var bookmarks = (StoreKeeper.store as OlamStore).bookmarks;
    String count = "no";
    if (bookmarks.length > 0) {
      count = bookmarks.length.toString();
    }
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8.0, left: 24.0),
              child: Text(
                "My bookmarks",
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8.0, right: 24.0),
              child: Text(
                count + " items",
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            itemCount: bookmarks.length,
            itemBuilder: (_, i) {
              return BookmarksItem(
                title: bookmarks[i].word,
                subtitle:
                    "${bookmarks[i].definitions.length} definition${bookmarks[i].definitions.length > 1 ? 's' : ''}",
                onDismiss: () {
                  RemoveFromBookmarks(i);
                },
                onPress: () {
                  SetMeaning(bookmarks[i]);
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (_) => Meaning()));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
