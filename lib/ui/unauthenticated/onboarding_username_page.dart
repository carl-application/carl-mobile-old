import 'package:carl/blocs/user_registration/user_registration_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_event.dart';
import 'package:carl/blocs/user_registration/user_registration_state.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/indicators.dart';
import 'package:carl/ui/unauthenticated/onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingUsernamePage extends StatelessWidget {
  OnBoardingUsernamePage({@required this.onUserNameSubmitted, this.onBackPressed, this.userName});

  final void Function(String) onUserNameSubmitted;
  final VoidCallback onBackPressed;
  String userName;

  final _usernameController = TextEditingController();

  void navigateToNext(String userName) {
    if (onUserNameSubmitted != null) {
      onUserNameSubmitted(userName);
    }
  }

  @override
  Widget build(BuildContext context) {
    _usernameController.text = userName;
    final fieldsColumnChildren = List<Widget>();
    fieldsColumnChildren.add(Container(
      width: 200,
      child: TextField(
        onSubmitted: (text) {
          userName = text;
          navigateToNext(text);
        },
        onChanged: (text) {
          userName = text;
        },
        controller: _usernameController,
        style: CarlTheme.of(context).whiteMediumLabel,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: Localization.of(context).onBoardingUsernameHint,
            hintStyle: CarlTheme.of(context).white30Label),
      ),
    ));

    fieldsColumnChildren.add(Text(
      Localization.of(context).onBoardingUsernameLabel,
      style: CarlTheme.of(context).white30Label,
    ));

    /*if (state is RegistrationFailed && state.isEmailAlreadyInDatabase) {
      fieldsColumnChildren.add(Text(
        Localization.of(context).emailAlreadyExistErrorMessage,
        style: CarlTheme.of(context).errorTextStyle,
      ));
    }*/
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
                      children: <Widget>[...fieldsColumnChildren],
                    )
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: Indicators(
                    topEnable: true,
                    bottomEnable: _usernameController.text.isNotEmpty,
                    onTopCLicked: () {
                      onBackPressed();
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
