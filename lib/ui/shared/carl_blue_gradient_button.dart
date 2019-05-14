import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../theme.dart';

class CarlBlueGradientButton extends StatelessWidget {
  CarlBlueGradientButton(
      {@required this.text,
      @required this.onPressed,
      this.width,
      this.height = 40,
      this.textStyle});

  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: CarlTheme.of(context).blueGradient,
            borderRadius: BorderRadius.circular(20.0)),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              if (onPressed != null) {
                onPressed();
              }
            },
            child: Container(
              width: width,
              height: height,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(text, style: textStyle),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
