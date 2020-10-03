import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  SquareButton({this.icon, this.padding, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          padding: padding,
          child: Icon(icon),
        ),
      ),
    );
  }
}
