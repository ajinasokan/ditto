import 'package:flutter/material.dart';

class SearchResult extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPress;

  SearchResult({this.title, this.subtitle, this.onPress});

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
