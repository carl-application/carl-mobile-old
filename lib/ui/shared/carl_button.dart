import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CarlButton extends StatelessWidget {
  CarlButton({
    @required this.text,
    @required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 30,
    this.color = Colors.white,
    this.textStyle
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double width;
  final double height;
  final Color color;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      disabledColor: Colors.white,
      colorBrightness: Theme.of(context).brightness,
      color: color,
      elevation: 10,
      padding: EdgeInsets.only(top: 20, right: 30, bottom: 20, left: 30),
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Container(
        height: height,
        width: width,
        child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Text(text, style: textStyle)),
      ),
      onPressed: isLoading ? null : onPressed,
    );
  }
}
