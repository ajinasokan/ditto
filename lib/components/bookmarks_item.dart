import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';

class BookmarksItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPress;
  final VoidCallback onDismiss;

  BookmarksItem({this.title, this.subtitle, this.onDismiss, this.onPress});

  Widget bullet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        shape: BoxShape.circle,
      ),
      height: 4.0,
      width: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title),
      onDismissed: (_) {
        onDismiss();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Container(
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
          child: Material(
            type: MaterialType.transparency,
            child: ListTile(
              leading: Icon(FeatherIcons.bookmark),
              title: Text(title),
              subtitle: Text(subtitle),
              onTap: onPress,
            ),
          ),
        ),
      ),
    );
  }
}
