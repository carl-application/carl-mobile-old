import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';

class ErrorApiCall extends StatelessWidget {
  final String errorTitle;
  final String errorDescription;

  const ErrorApiCall({Key key, this.errorTitle, this.errorDescription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * .2;
    return Scaffold(
      body: Center(
        child: Column(
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
                  width: imageSize,
                  height: imageSize,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              errorTitle,
              style: CarlTheme.of(context).blackTitle,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              errorDescription,
              style: CarlTheme.of(context).blackMediumLabel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
