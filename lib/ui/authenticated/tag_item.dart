import 'package:flutter/material.dart';

class TagItem extends StatelessWidget {
  final Color color;
  final String name;
  final TextStyle textStyle;

  const TagItem({Key key, this.color, this.name, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        color: color,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Text(
              name,
              style: textStyle,
            textAlign: TextAlign.center,
          ),
        )),
      ),
    );
  }
}
