import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';

class EmptyElement extends StatelessWidget {
  final String assetImageUrl;
  final String title;
  final String description;

  const EmptyElement({Key key, this.assetImageUrl, this.title, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * .3;
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
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  assetImageUrl,
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
              title,
              style: CarlTheme.of(context).blackTitle,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              description,
              style: CarlTheme.of(context).blackMediumLabel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
