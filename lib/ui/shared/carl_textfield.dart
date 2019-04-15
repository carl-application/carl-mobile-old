import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CarlTextField extends StatelessWidget {
  CarlTextField(
      {@required this.hintText,
      @required this.controller,
      this.obscureText = false});

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(color: Colors.black)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        textDirection: TextDirection.ltr,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintStyle: TextStyle(
            color: Colors.grey[800],
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
