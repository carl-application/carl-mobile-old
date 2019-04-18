import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingSexBirthdayPage extends StatefulWidget {
  OnBoardingSexBirthdayPage();

  @override
  OnBoardingSexBirthdayPageState createState() {
    return OnBoardingSexBirthdayPageState();
  }
}

class OnBoardingSexBirthdayPageState extends State<OnBoardingSexBirthdayPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Stack(
            children: <Widget>[],
          ),
        )),
      ),
    );
  }
}
