import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  final String assetIcon;
  final Color backgroundColor;

  const RoundedIcon({Key key, this.assetIcon, this.backgroundColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          assetIcon,
          height: 25,
          width: 25,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
