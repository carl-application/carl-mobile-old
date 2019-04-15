import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/carl_face.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({@required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CarlFace(size: 200,),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Bienvenue sur Carl !",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "L’assistant de fidélité soucieux de votre vie privée",
                  style: Theme.of(context).textTheme.body1,
                ),
                SizedBox(
                  height: 40,
                ),
                CarlButton(
                  text: "Créer un compte",
                  onPressed: () {
                    this.onNext();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                CarlButton(
                  text: "J'ai déjà un compte !",
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
