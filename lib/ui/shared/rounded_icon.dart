import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  final String assetIcon;
  final Color backgroundColor;
  final VoidCallback onClick;
  final double iconSize;
  final double padding;

  const RoundedIcon({
    Key key,
    this.assetIcon,
    this.backgroundColor = Colors.white,
    this.onClick,
    this.iconSize,
    this.padding
  })
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
            padding: EdgeInsets.all(padding ?? 10),
            child: Image.asset(
              assetIcon,
              height: this.iconSize ?? 20,
              width: this.iconSize ?? 20,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
