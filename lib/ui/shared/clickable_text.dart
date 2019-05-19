import 'package:flutter/material.dart';

class ClickableText extends StatefulWidget {
  final Color clickedColor;
  final String text;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final TextStyle textStyle;
  final VoidCallback onClick;

  const ClickableText(
      {Key key,
      this.clickedColor,
      this.text,
      this.textAlign,
      this.textDirection,
      this.textStyle,
      this.onClick})
      : super(key: key);

  @override
  _ClickableTextState createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  var selected = false;

  _toggleSelected() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appliedTextStyle =
        selected ? widget.textStyle.apply(color: widget.clickedColor) : widget.textStyle;

    return GestureDetector(
      onTapDown: (detail) => _toggleSelected(),
      onTapUp:  (detail) {
        _toggleSelected();
        if(widget.onClick != null) {
          widget.onClick();
        }
      },
      onLongPressEnd: (detail){
        _toggleSelected();
      },
      child: Text(widget.text,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          style: appliedTextStyle),
    );
  }
}
