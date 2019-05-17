import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CarlTextField extends StatelessWidget {
  CarlTextField(
      {@required this.hintText,
      @required this.controller,
      this.obscureText = false,
      this.textStyle,
      this.hintStyle,
      this.textInputAction,
      this.onSubmitted,
      this.focusNode});

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextStyle textStyle;
  final TextStyle hintStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Color.fromRGBO(255, 255, 255, .2)
      ),
      child: TextField(
        onSubmitted: (text) => onSubmitted(text),
        focusNode: focusNode,
        textAlign: TextAlign.center,
        controller: controller,
        textInputAction: textInputAction,
        style: textStyle ?? TextStyle(color: Colors.white, fontSize: 20),
        textDirection: TextDirection.ltr,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: false,
          hintStyle: hintStyle ??
              TextStyle(
                color: Colors.white,
              ),
          hintText: hintText,
        ),
      ),
    );
  }
}
