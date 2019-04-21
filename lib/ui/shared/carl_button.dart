import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CarlButton extends StatelessWidget {
  CarlButton({@required this.text, @required this.onPressed, this.isLoading = false});

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      disabledColor: Colors.white,
      colorBrightness: Theme.of(context).brightness,
      color: Colors.white,
      elevation: 10,
      padding: EdgeInsets.only(top: 20, right: 30, bottom: 20, left: 30),
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Container(
        height: 30,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
            child: isLoading ? CircularProgressIndicator() : Text(text, style: CarlTheme.of(context).bigButtonLabelStyle)),
      ),
      onPressed: isLoading ? null : onPressed,
    );
  }
}
