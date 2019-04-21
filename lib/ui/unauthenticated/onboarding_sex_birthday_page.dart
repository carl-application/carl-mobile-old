import 'package:carl/localization/localization.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/date_chooser.dart';
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
    return WillPopScope(
      onWillPop: widget.onBackPressed,
      child: Material(
        child: Container(
          decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
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
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 280,
                        child: Text(
                          Localization.of(context).getBirthdayLabel.toUpperCase(),
                          style: CarlTheme.of(context).white30Label,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DateChooser(
                        date: DateTime.utc(1994, 3, 5),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      CarlButton(
                        text: Localization.of(context).validate.toUpperCase(),
                        onPressed: () {},
                      )
                    ],
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
