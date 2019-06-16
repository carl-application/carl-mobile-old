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

  get pageHorizontalPadding => 18.0;

  get pageVerticalPadding => 20.0;

  get pagePadding =>
      EdgeInsets.symmetric(vertical: pageVerticalPadding, horizontal: pageHorizontalPadding);

  // Colors
  get primaryColor => Color.fromRGBO(0, 125, 253, 1);

  get accentColor => Color.fromRGBO(0, 71, 250, 1);

  get background => Color.fromRGBO(248, 249, 251, 1);

  get scannerBlackBorder => Color.fromRGBO(74, 74, 74, 1);

  get mainGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 1],
        colors: [
          primaryColor,
          accentColor,
        ],
      );

  get orangeGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.2, 1],
        colors: [
          Color.fromRGBO(250, 217, 97, 1),
          Color.fromRGBO(247, 107, 28, 1),
        ],
      );

  get blueGradient => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [0.25, 1],
        colors: [
          Color.fromRGBO(0, 71, 250, 1),
          Color.fromRGBO(0, 125, 253, 1),
        ],
      );

  get horizontalGradient => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: [0.3, 1],
        colors: [
          accentColor,
          primaryColor,
        ],
      );

  get tagsColors => [Colors.green, Colors.purpleAccent, Colors.pink];

  get percentIndicatorCompleteColor => Color.fromRGBO(126, 211, 33, 1);

  // TextStyles
  get title => TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold);

  get bigBlackTitle => TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold);

  get blackTitle => TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold);

  get black12MediumLabel => TextStyle(color: Colors.black54, fontSize: 18);

  get greyMediumLabel => TextStyle(color: Colors.grey, fontSize: 18);

  get greyLittleLabel => TextStyle(color: Colors.grey, fontSize: 16);

  get blackMediumLabel => TextStyle(color: Colors.black, fontSize: 18);

  get blackMediumBoldLabel =>
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);

  get whiteBigLabel => TextStyle(color: Colors.white, fontSize: 18);

  get whiteBoldBigLabel => TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

  get blueTitle => TextStyle(color: accentColor, fontSize: 24, fontWeight: FontWeight.bold);

  get notificationDetailBusinessName => TextStyle(color: Color.fromRGBO(10,37,73, 1), fontSize: 24, fontWeight: FontWeight.bold);

  get notificationDetailDescription => TextStyle(color: Color.fromRGBO(10,37,73, .5), fontSize: 16);
  
  get notificationDetailTitle => TextStyle(color: Color.fromRGBO(10,37,73, .8), fontSize: 20);

  get blueBigLabel => TextStyle(color: accentColor, fontSize: 18);

  get blueSmallLabel => TextStyle(color: accentColor, fontSize: 15);

  get blackSmallLabel => TextStyle(color: Colors.black, fontSize: 15);

  get whiteMediumLabel => TextStyle(color: Colors.white, fontSize: 14);

  get bigButtonLabelStyle =>
      TextStyle(fontSize: 16, color: accentColor, fontWeight: FontWeight.bold);

  get white30Label => TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8), fontSize: 16);

  get bigNumber => TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold);

  get blackBigNumber => TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold);

  get blackMediumNumber => TextStyle(color: Colors.black, fontSize: 18);

  get errorTextStyle => TextStyle(color: Colors.redAccent, fontSize: 18);

  get littleNumberWhite30 => TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.8),
        fontSize: 16,
      );
}
