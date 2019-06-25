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

    var hasUppercase = false;
    var hasNumber = false;
    for (var index = 0; index < password.length; index++) {
      if (_isNumeric(password[index])) {
        hasNumber = true;
      } else {
        if (password[index] == password[index].toUpperCase()) {
          hasUppercase = true;
        }
      }
    }

    if (!hasUppercase || !hasNumber) {
      setState(() {
        error = Translations.of(context).text("on_boarding_password_uppercase_error");
      });
      return;
    }

    if (widget.onPasswordSubmitted != null) {
      widget.onPasswordSubmitted(password);
    }
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
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
    _passwordController.selection = TextSelection.fromPosition(TextPosition(offset: _passwordController.text.length));
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
                    width: MediaQuery.of(context).size.width *.9,
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
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
                        Container(
                          width: MediaQuery.of(context).size.width * 2,
                          child: Text(
                            Translations.of(context).text("on_boarding_password_label"),
                            style: CarlTheme.of(context).white30Label,
                          ),
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
