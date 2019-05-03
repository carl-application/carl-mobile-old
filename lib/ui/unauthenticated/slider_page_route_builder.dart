import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';

class SliderRouteBuilder extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;

  SliderRouteBuilder({this.exitPage, this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>

              Stack(
                children: <Widget>[
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(0.0, -1.0),
                    ).animate(animation),
                    child: CarlTheme(child: exitPage),
                  ),
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: CarlTheme(child: enterPage),
                  )
                ],
              ),
        );
}
