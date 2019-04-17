import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/onboarding_position_counter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingUsernamePage extends StatelessWidget {
  OnBoardingUsernamePage({@required this.position, @required this.total});

  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
        child: SafeArea(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    child: FlareActor("animations/carl_face.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        animation: "pulsation"),
                  ),
                  OnBoardingPositionCounter(
                    position: position,
                    total: total,
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
