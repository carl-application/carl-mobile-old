import 'package:carl/localization/localization.dart';
import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/indicators.dart';
import 'package:carl/ui/unauthenticated/onboarding_position_counter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingUsernamePage extends StatelessWidget {
  OnBoardingUsernamePage({@required this.position, @required this.total});

  final _usernameController = TextEditingController();
  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(gradient: CarlTheme.of(context).mainGradient),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 150,
                              height: 150,
                              child: Hero(
                                tag: "carl_face",
                                child: FlareActor(
                                  "animations/carl_face.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            OnBoardingPositionCounter(
                              position: position,
                              total: total,
                            )
                          ],
                        ),
                      ),
                      Text(
                        Localization.of(context).onBoardingUsernameTitle,
                        style: CarlTheme.of(context).title,
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 100,
                child: Container(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 200,
                        child: TextField(
                          controller: _usernameController,
                          style: CarlTheme.of(context).whiteMediumLabel,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Localization.of(context)
                                  .onBoardingUsernameHint,
                              hintStyle: CarlTheme.of(context).white30Label),
                        ),
                      ),
                      Text(
                        Localization.of(context).onBoardingUsernameLabel,
                        style: CarlTheme.of(context).white30Label,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Indicators(
                    topEnable: true,
                    bottomEnable: _usernameController.text.isNotEmpty,
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
