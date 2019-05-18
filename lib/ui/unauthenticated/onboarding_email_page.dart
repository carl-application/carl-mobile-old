import 'package:carl/localization/localization.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/indicators.dart';
import 'package:carl/ui/unauthenticated/onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingEmailPage extends StatelessWidget {
  OnBoardingEmailPage({
    @required this.onEMailSubmitted,
    this.onBackPressed,
    this.email,
  });

  final void Function(String) onEMailSubmitted;
  final VoidCallback onBackPressed;
  String email;

  final _emailController = TextEditingController();

  void navigateToNext(String email) {
    if (onEMailSubmitted != null) {
      onEMailSubmitted(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    _emailController.text = email;
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
                      title: Localization.of(context).onBoardingEmailTitle,
                      position: 2,
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
                          width: 200,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            onSubmitted: (text) {
                              email = text;
                              navigateToNext(text);
                            },
                            controller: _emailController,
                            style: CarlTheme.of(context).whiteMediumLabel,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: Localization.of(context).onBoardingEmailHint,
                                hintStyle: CarlTheme.of(context).white30Label),
                          ),
                        ),
                        Text(
                          Localization.of(context).onBoardingEmailLabel,
                          style: CarlTheme.of(context).white30Label,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: Indicators(
                    topEnable: true,
                    bottomEnable: _emailController.text.isNotEmpty,
                    onTopCLicked: () {
                      onBackPressed();
                    },
                    onDownClicked: () {
                      navigateToNext(_emailController.text);
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
