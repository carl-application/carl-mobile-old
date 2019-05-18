import 'package:carl/ui/theme.dart';
import 'package:carl/ui/unauthenticated/onboarding_position_counter.dart';
import 'package:flutter/widgets.dart';

class OnBoardingHeader extends StatelessWidget {
  OnBoardingHeader({@required this.title, @required this.position});

  final String title;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 70,
              width: 70,
              child: Image.asset(
                "assets/ic_carl.png",
                fit: BoxFit.cover,
              ),
            ),
            OnBoardingPositionCounter(
              position: position,
              total: 4,
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          title,
          style: CarlTheme.of(context).title,
        ),
      ],
    );
  }
}
