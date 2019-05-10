import 'package:carl/localization/localization.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/clickable_text.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({this.onRegisterAsked});

  final VoidCallback onRegisterAsked;

  _navigateToLogin(context) {
    Navigator.of(context).pushNamed(LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        child: Image.asset(
                          "assets/ic_carl.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(Localization.of(context).welcomePageTitle,
                                  textAlign: TextAlign.center, style: CarlTheme.of(context).title),
                              SizedBox(
                                height: 30,
                              ),
                              Text(Localization.of(context).welcomePageSubtitle,
                                  textAlign: TextAlign.center,
                                  style: CarlTheme.of(context).whiteMediumLabel)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CarlButton(
                          text: Localization.of(context).welcomePageRegisterButtonLabel,
                          textStyle: CarlTheme.of(context).bigButtonLabelStyle,
                          onPressed: () {
                            onRegisterAsked();
                          },
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ClickableText(
                            text: Localization.of(context).welcomePageLoginButtonLabel,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            textStyle: CarlTheme.of(context).white30Label,
                            clickedColor: CarlTheme.of(context).primaryColor,
                            onClick: () {
                              _navigateToLogin(context);
                            },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
