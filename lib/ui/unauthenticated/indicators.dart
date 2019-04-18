import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Indicators extends StatelessWidget {
  Indicators(
      {@required this.topEnable,
      @required this.bottomEnable,
      @required this.onTopCLicked,
      @required this.onDownClicked,
      this.hideBottom});

  final bool topEnable;
  final bool bottomEnable;
  final bool hideBottom;
  final VoidCallback onTopCLicked;
  final VoidCallback onDownClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            if (topEnable) {
              onTopCLicked();
            }
          },
          child: Icon(
            Icons.expand_less,
            size: 40,
            color: topEnable ? Colors.white : Colors.white30,
          ),
        ),
        InkWell(
          onTap: () {
            if (bottomEnable) {
              onDownClicked();
            }
          },
          child: Icon(
            Icons.expand_more,
            size: 40,
            color: bottomEnable ? Colors.white : Colors.white30,
          ),
        ),
      ],
    );
  }
}
