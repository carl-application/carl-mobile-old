import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CarlButton extends StatelessWidget {
  CarlButton(
      {@required this.text,
      @required this.onPressed,
      this.isLoading = false,
      this.width,
      this.height = 20,
      this.color = Colors.white,
      this.elevation = 10,
      this.textStyle});

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double width;
  final double height;
  final Color color;
  final TextStyle textStyle;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      disabledColor: Colors.white,
      colorBrightness: Theme.of(context).brightness,
      color: color,
      elevation: elevation,
      padding: EdgeInsets.only(top: 15, right: 30, bottom: 15, left: 30),
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Container(
        width: width,
        height: height,
        child: Center(
            child: isLoading
                ? Container(height: 20, width: 20, child: CircularProgressIndicator())
                : Text(text, style: textStyle)),
      ),
      onPressed: isLoading ? null : onPressed,
    );
  }
}
