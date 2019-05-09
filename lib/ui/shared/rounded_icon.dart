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
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Material(
        type: MaterialType.circle,
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            print("ok");
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              assetIcon,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
