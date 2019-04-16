import 'package:carl/ui/unauthenticated/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UnauthenticatedNavigation extends StatefulWidget {
  @override
  UnauthenticatedNavigationState createState() =>
      UnauthenticatedNavigationState();
}

class UnauthenticatedNavigationState extends State<UnauthenticatedNavigation> {
  final PageController _controller = PageController();
  final _navigationAnimationTimeInSeconds = 2;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PageView(
        scrollDirection: Axis.vertical,
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          WelcomePage(
            onNext: () {
              _controller.animateToPage(1,
                  duration: Duration(seconds: _navigationAnimationTimeInSeconds),
                  curve: Curves.easeInOut);
            },
          ),
          Container(
            child: Center(
              child: RaisedButton(
                  child: Text(
                    "back",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _controller.animateToPage(0,
                        duration: Duration(seconds: _navigationAnimationTimeInSeconds),
                        curve: Curves.easeInOut);
                  }),
            ),
          ),
          Container(
            color: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}
