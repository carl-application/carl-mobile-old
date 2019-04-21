import 'package:carl/localization/localization.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/indicators.dart';
import 'package:carl/ui/unauthenticated/onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingUsernamePage extends StatefulWidget {
  OnBoardingUsernamePage({@required this.onUserNameSubmitted, this.onBackPressed, this.userName});

  final void Function(String) onUserNameSubmitted;
  final VoidCallback onBackPressed;
  final String userName;

  @override
  OnBoardingUsernamePageState createState() {
    return OnBoardingUsernamePageState();
  }
}

class OnBoardingUsernamePageState extends State<OnBoardingUsernamePage> {
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.userName;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void navigateToNext(String userName) {
    widget.onUserNameSubmitted(userName);
  }

  @override
  Widget build(BuildContext context) {
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
                      title: Localization.of(context).onBoardingUsernameTitle,
                      position: 1,
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
                            onSubmitted: (text) {
                              navigateToNext(text);
                            },
                            controller: _usernameController,
                            style: CarlTheme.of(context).whiteMediumLabel,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: Localization.of(context).onBoardingUsernameHint,
                                hintStyle: CarlTheme.of(context).white30Label),
                          ),
                        ),
                        Text(
                          Localization.of(context).onBoardingUsernameLabel,
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
                    bottomEnable: _usernameController.text.isNotEmpty,
                    onTopCLicked: () {
                      widget.onBackPressed();
                    },
                    onDownClicked: () {
                      navigateToNext(_usernameController.text);
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
