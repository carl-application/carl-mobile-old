import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/carl_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
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
                          size: 30,
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
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    CarlTextField(
                      hintText: "Email",
                      controller: _usernameController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CarlTextField(
                      hintText: "Password",
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CarlButton(
                      text: "Valider",
                      onPressed: () {

                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
