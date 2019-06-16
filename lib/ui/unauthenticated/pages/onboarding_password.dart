import 'package:carl/translations.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/indicators.dart';
import 'package:carl/ui/unauthenticated/onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingPassword extends StatefulWidget {
  OnBoardingPassword({
    @required this.onPasswordSubmitted,
    this.onBackPressed,
    this.password
  });

  final void Function(String) onPasswordSubmitted;
  final VoidCallback onBackPressed;
  String password;

  @override
  _OnBoardingPasswordState createState() => _OnBoardingPasswordState();
}

class _OnBoardingPasswordState extends State<OnBoardingPassword> {
  final _passwordController = TextEditingController();
  String error = "";

  void navigateToNext(String password) {
    if (password.length < 6) {
      setState(() {
        error = Translations.of(context).text("on_boarding_password_length_error");
      });
      return;
    }
    bool hasOneUppercase = false;
    for (int i = 0; i < password.length; i++) {
      if (password[i] == password[i].toUpperCase()) {
        hasOneUppercase = true;
        break;
      }
    }

    if (!hasOneUppercase) {
      setState(() {
        error = Translations.of(context).text("on_boarding_password_uppercase_error");
      });
      return;
    }
    if (widget.onPasswordSubmitted != null) {
      widget.onPasswordSubmitted(password);
    }
  }

  Widget showError() {
      if (this.error.isNotEmpty) {
        return Text(
          this.error,
          style: CarlTheme.of(context).errorTextStyle,
          maxLines: 2,
        );
      } else {
        return Container();
      }
  }

  @override
  Widget build(BuildContext context) {
    _passwordController.text = widget.password;
    return WillPopScope(
      onWillPop: widget.onBackPressed,
      child: Material(
        child: Container(
          decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    OnBoardingHeader(
                      title: Translations.of(context).text("on_boarding_password_title"),
                      position: 3,
                    ),
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.45,
                  child: Container(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 300,
                          child: TextField(
                            obscureText: true,
                            onSubmitted: (text) {
                              widget.password = text;
                              navigateToNext(text);
                            },
                            onChanged: (text) {
                              widget.password = text;
                            },
                            controller: _passwordController,
                            style: CarlTheme.of(context).whiteMediumLabel,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: Translations.of(context).text("on_boarding_password_hint"),
                                hintStyle: CarlTheme.of(context).white30Label),
                          ),
                        ),
                        Text(
                          Translations.of(context).text("on_boarding_password_label"),
                          style: CarlTheme.of(context).white30Label,
                        ),
                        showError()
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: Indicators(
                    topEnable: true,
                    bottomEnable: _passwordController.text.isNotEmpty,
                    onTopCLicked: () {
                      widget.onBackPressed();
                    },
                    onDownClicked: () {
                      navigateToNext(_passwordController.text);
                    },
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
