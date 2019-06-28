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
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
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
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
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
          ),
        ],
      ),
    );
  }
}
