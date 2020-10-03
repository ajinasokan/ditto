import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:store_keeper/store_keeper.dart';

import 'package:ditto/app.dart';

class Index extends StatefulWidget {
  const Index();

  @override
  IndexState createState() {
    return new IndexState();
  }
}

class IndexState extends State<Index> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var datukWords = (StoreKeeper.store as OlamStore).datukWords;
    var olamWords = (StoreKeeper.store as OlamStore).olamWords;
    var store = (StoreKeeper.store as OlamStore);

    StoreKeeper.listen(context, to: [
      LoadWords,
      LoadStore,
    ]);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8.0, left: 24.0),
              child: Text(
                "Index of words",
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8.0, right: 24.0),
              child: Text(
                "${datukWords.length + olamWords.length} items",
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ],
        ),
        Expanded(
          child: DraggableScrollbar.semicircle(
            controller: scrollController,
            child: ListView.builder(
              itemExtent: 50.0,
              controller: scrollController,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              itemCount: datukWords.length + olamWords.length,
              itemBuilder: (_, i) {
                return InkWell(
                  onTap: () {
                    FetchMeaning(SearchWord.getWordAt(i, store));
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (_) => Meaning()));
                  },
                  child: Container(
                    height: 50.0,
                    margin: EdgeInsets.only(
                      left: 24.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.withAlpha(30))),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          SearchWord.getWordAt(i, store).word,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
