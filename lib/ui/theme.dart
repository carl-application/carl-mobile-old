import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CarlTheme extends InheritedWidget {
  CarlTheme({
    @required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static CarlTheme of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(CarlTheme);
  }

  // Dimensions
  get generalPadding => 20.0;

  // Colors
  get primaryColor => Color.fromRGBO(0, 125, 253, 1);

  get accentColor => Color.fromRGBO(0, 71, 250, 1);

  get mainGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 1],
        colors: [
          primaryColor,
          accentColor,
        ],
      );

  // TextStyles
  get title =>
      TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold);

  get whiteBigLabel => TextStyle(color: Colors.white, fontSize: 22);

  get blueBigLabel => TextStyle(color: primaryColor, fontSize: 22);

  get whiteMediumLabel => TextStyle(color: Colors.white, fontSize: 22);

  get bigButtonLabelStyle =>
      TextStyle(fontSize: 20, color: accentColor, fontWeight: FontWeight.bold);

  get white30Label =>
      TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8), fontSize: 20);

  get bigNumber =>
      TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold);

  get littleNumberWhite30 => TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.8),
        fontSize: 16,
      );
}
