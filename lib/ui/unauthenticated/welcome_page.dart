import "package:flare_flutter/flare_actor.dart";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({@required this.onNext});

  final VoidCallback onNext;

  @override
  WelcomePageState createState() {
    return WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage> {
  Widget renderRegisterButton() {
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
          "SALUT CARL !",
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold),
        )),
      ),
      onPressed: () {
        this.widget.onNext();
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
                            Text("Hello, moi c'est CARL !",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.title),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                                "L'assistant de fidélité soucieux de votre vie privée",
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
                      this.renderRegisterButton(),
                      SizedBox(
                        height: 30,
                      ),
                      Text("J'AI DEJA UN COMPTE",
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
