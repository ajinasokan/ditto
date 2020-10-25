import 'package:ditto/app.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: 80,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              flavour.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top + 80),
      ),
      body: [
        () => Search(),
        () => Bookmarks(),
        () => Index(),
        () => Settings(),
      ][index](),
      bottomNavigationBar: Theme(
        data: Theme.of(context),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            index = value;
            setState(() {});
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.search),
              title: Text(flavour.searchTab),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.bookmark),
              title: Text(flavour.bookmarkTab),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.list),
              title: Text(flavour.wordIndexTab),
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.settings),
              title: Text(flavour.settingsTab),
            ),
          ],
        ),
      ),
    );
  }
}
