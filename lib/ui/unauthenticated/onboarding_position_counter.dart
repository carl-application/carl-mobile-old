import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingPositionCounter extends StatelessWidget {
  OnBoardingPositionCounter({@required this.position, @required this.total});

  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text("$position", style: CarlTheme.of(context).bigNumber),
              SizedBox(
                height: 30,
              )
            ],
          ),
          SizedBox(
            width: 5,
          ),
          Text("/", style: CarlTheme.of(context).littleNumberWhite30),
          Text("$total", style: CarlTheme.of(context).littleNumberWhite30),
        ],
      ),
    );
  }
}
