import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:store_keeper/store_keeper.dart';

import 'package:ditto/app.dart';

class Search extends StatefulWidget {
  const Search();

  @override
  SearchState createState() {
    return new SearchState();
  }
}

class SearchState extends State<Search>
    with WidgetsBindingObserver, StoreAccess {
  final editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editingController.text = store.query;
    editingController.addListener(() {
      SearchWord(editingController.text);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      var data = await Clipboard.getData(Clipboard.kTextPlain);
      var text = data?.text ?? "";
      CheckClippedString(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    StoreKeeper.listen(context, to: [
      SearchWord,
      RemoveFromRecent,
      AddToRecent,
    ]);

    OlamStore store = StoreKeeper.store;
    var recent = store.recent;
    var results = store.searchResults;
    var searchMode = editingController.text.trim() != "";

    String title = searchMode ? "Search results" : "Recent lookups";
    String count = "no";
    if (searchMode) {
      if (results.length == 100) {
        count = "~100";
      } else if (results.length > 0) {
        count = results.length.toString();
      }
    } else {
      if (recent.length == 100) {
        count = "~100";
      } else if (recent.length > 0) {
        count = recent.length.toString();
      }
    }
    count += " items";
    return NotifyOn(
      mutations: {
        SetClippedString: (_, __) {
          editingController.text = store.clippedString;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              top: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(width: 16.0),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: editingController,
                      onSubmitted: (query) {
                        if (results.length > 0) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          FetchMeaning(results[0]);
                          Navigator.of(context).push(
                            CupertinoPageRoute(builder: (_) => Meaning()),
                          );
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: flavour.searchHint),
                    ),
                  ),
                  SquareButton(
                    padding: EdgeInsets.only(
                        top: 6.0, bottom: 8.0, right: 8.0, left: 8.0),
                    icon: FeatherIcons.x,
                    onPressed: () {
                      editingController.clear();
                    },
                  ),
                  Container(width: 4),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0, left: 24.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8.0, right: 24.0),
                child: Text(
                  count,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              itemCount: searchMode ? results.length : recent.length,
              itemBuilder: (_, i) {
                if (searchMode)
                  return SearchResult(
                    onPress: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      FetchMeaning(results[i]);
                      Navigator.of(context).push(
                        CupertinoPageRoute(builder: (_) => Meaning()),
                      );
                    },
                    title: results[i].word,
                    subtitle:
                        "${results[i].definitionCount} definition${results[i].definitionCount > 1 ? 's' : ''}",
                  );
                else
                  return RecentItem(
                    onPress: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      SetMeaning(recent[i]);
                      Navigator.of(context)
                          .push(CupertinoPageRoute(builder: (_) => Meaning()));
                    },
                    onDismiss: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      RemoveFromRecent(i);
                    },
                    title: recent[i].word,
                    subtitle:
                        "${recent[i].definitions.length} definition${recent[i].definitions.length > 1 ? 's' : ''}",
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
