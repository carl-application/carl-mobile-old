import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  final String assetIcon;
  final Color backgroundColor;
  final VoidCallback onClick;

  const RoundedIcon({Key key, this.assetIcon, this.backgroundColor = Colors.white, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if(this.onClick != null) {
              this.onClick();
            }
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
