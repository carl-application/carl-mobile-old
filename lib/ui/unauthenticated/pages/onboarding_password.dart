import 'package:carl/translations.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/indicators.dart';
import 'package:carl/ui/unauthenticated/onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingPassword extends StatelessWidget {
  OnBoardingPassword({
    @required this.onPasswordSubmitted,
    this.onBackPressed,
    this.password
  });

  final void Function(String) onPasswordSubmitted;
  final VoidCallback onBackPressed;
  String password;

  final _passwordController = TextEditingController();

  void navigateToNext(String password) {
    if (onPasswordSubmitted != null) {
      onPasswordSubmitted(password);
    }
  }

  @override
  Widget build(BuildContext context) {
    _passwordController.text = password;
    return WillPopScope(
      onWillPop: onBackPressed,
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
                              password = text;
                              navigateToNext(text);
                            },
                            onChanged: (text) {
                              password = text;
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
                        )
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
                      onBackPressed();
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
