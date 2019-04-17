import 'package:carl/blocs/user_registration/user_registration_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_event.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/ui/theme.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage();

  Widget renderRegisterButton(BuildContext context) {
    return RaisedButton(
      colorBrightness: Theme.of(context).brightness,
      color: Colors.white,
      elevation: 10,
      padding: EdgeInsets.only(top: 20, right: 30, bottom: 20, left: 30),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
            child: Text(Localization.of(context).welcomePageRegisterButtonLabel,
                style: CarlTheme.of(context).bigButtonLabelStyle)),
      ),
      onPressed: () {
        final registrationBloc = BlocProvider.of<UserRegistrationBloc>(context);
        registrationBloc.dispatch(StartRegistrationEvent());
      },
    );
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
                    child: Container(
                      child: Hero(
                        tag: "carl_face",
                        child: FlareActor("animations/carl_face.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                            animation: "pulsation"),
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
                                  textAlign: TextAlign.center,
                                  style: CarlTheme.of(context).title),
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
                        this.renderRegisterButton(context),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                            Localization.of(context)
                                .welcomePageLoginButtonLabel,
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
