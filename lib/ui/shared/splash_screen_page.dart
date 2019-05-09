import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: CarlTheme.of(context).primaryColor
    ));
    return Container(
      color: CarlTheme.of(context).primaryColor,
      child: Center(
        child: Center(
          child: Container(
            height: 150,
            width: 150,
            child: Image.asset(
              "assets/ic_carl.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
