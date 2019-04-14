import 'package:carl/ui/unauthenticated/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UnauthenticatedNavigation extends StatefulWidget {
  @override
  UnauthenticatedNavigationState createState() =>
      UnauthenticatedNavigationState();
}

class UnauthenticatedNavigationState extends State<UnauthenticatedNavigation> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PageView(
        scrollDirection: Axis.vertical,
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          WelcomePage(
            onNext: () {
              controller.animateToPage(1,
                  duration: Duration(seconds: 1),
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
                    controller.animateToPage(0,
                        duration: Duration(seconds: 1),
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
