import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToggleChooser extends StatefulWidget {
  ToggleChooser({@required this.choices});

  final List<String> choices;

  @override
  _ToggleChooserState createState() => _ToggleChooserState();
}

class _ToggleChooserState extends State<ToggleChooser> {
  get choices => widget.choices;

  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        width: double.infinity,
        child: Row(
          children: buildElements(this._selectedIndex),
        ));
  }

  List<Widget> buildElements(int selectedIndex) {
    final List<Widget> widgets = [];

    for (var index = 0; index < choices.length; index++) {
      if (selectedIndex == index) {
        widgets.add(Expanded(
            key: Key("$index"),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Text(
                    choices[index].toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: CarlTheme.of(context).blueBigLabel,
                  ),
                ),
              ),
            )));
      } else {
        final textWidget = Text(
          choices[index].toString().toUpperCase(),
          textAlign: TextAlign.center,
          style: CarlTheme.of(context).whiteBigLabel,
        );

        widgets.add(Expanded(
            key: Key("$index"),
            child: InkWell(
              child: textWidget,
              onTap: () {
                setState(() {
                  this._selectedIndex = index;
                });
              },
            )));
      }
    }

    return widgets;
  }
}
