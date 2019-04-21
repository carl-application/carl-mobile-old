import 'package:carl/localization/localization.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/theme.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({this.onRegisterAsked});

  final VoidCallback onRegisterAsked;

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
                    child: Container(
                      child: Hero(
                        tag: "carl_face",
                        child: FlareActor("animations/carl_face.flr",
                            alignment: Alignment.center, fit: BoxFit.cover, animation: "pulsation"),
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
                          onPressed: () {
                            onRegisterAsked();
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(Localization.of(context).welcomePageLoginButtonLabel,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: CarlTheme.of(context).white30Label)
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
