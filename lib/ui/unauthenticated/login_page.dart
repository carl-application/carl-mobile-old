import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              Center(
                child: Hero(
                  tag: "carl_face",
                  child: Image.asset(
                    "assets/carl_face.png",
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
