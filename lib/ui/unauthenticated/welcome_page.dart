import 'package:carl/localization/localization.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({@required this.onNext});

  final VoidCallback onNext;

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
            child: Text(
          Localization.of(context).welcomePageRegisterButtonLabel,
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold),
        )),
      ),
      onPressed: () {
        this.onNext();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 1],
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor,
          ],
        ),
      ),
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
                    child: FlareActor("animations/carl_face.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        animation: "pulsation"),
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
                            Text( Localization.of(context).welcomePageTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.title),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                                Localization.of(context).welcomePageSubtitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.body1)
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
                      Text( Localization.of(context).welcomePageLoginButtonLabel,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: Theme.of(context).textTheme.body2)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
