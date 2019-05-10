import 'package:carl/localization/localization.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';

class ErrorServer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration:
              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1000.0)),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Image.asset(
              "assets/carl_face.png",
              fit: BoxFit.contain,
              width: 120,
              height: 120,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          Localization.of(context).errorServerTitle,
          style: CarlTheme.of(context).blackTitle,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          Localization.of(context).errorServerDescription,
          style: CarlTheme.of(context).blackMediumLabel,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
