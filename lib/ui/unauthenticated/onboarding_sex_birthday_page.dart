import 'package:carl/localization/localization.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/indicators.dart';
import 'package:carl/ui/unauthenticated/onboarding_header.dart';
import 'package:carl/ui/unauthenticated/toggle_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingSexBirthdayPage extends StatefulWidget {
  OnBoardingSexBirthdayPage({@required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  OnBoardingSexBirthdayPageState createState() {
    return OnBoardingSexBirthdayPageState();
  }
}

class OnBoardingSexBirthdayPageState extends State<OnBoardingSexBirthdayPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                      title: Localization.of(context).onBoardingSexAndAgeTitle, position: 2),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    Localization.of(context).yourSexLabel.toUpperCase(),
                    style: CarlTheme.of(context).white30Label,
                  ),
                  ToggleChooser(
                    choices: [
                      Localization.of(context).nc,
                      Localization.of(context).man,
                      Localization.of(context).woman
                    ],
                  )
                ],
              ),
              Positioned(
                bottom: 40,
                right: 20,
                child: Indicators(
                  topEnable: true,
                  bottomEnable: false,
                  onTopCLicked: () {
                    widget.onBackPressed();
                  },
                  onDownClicked: () {},
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
