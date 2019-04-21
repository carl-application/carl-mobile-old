import 'package:carl/localization/localization.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DateController {
  DateTime date = new DateTime.now();
}

class DateChooser extends StatefulWidget {
  DateChooser({this.date, this.dateController});

  DateTime date;
  DateController dateController;

  @override
  _DateChooserState createState() => _DateChooserState();
}

class _DateChooserState extends State<DateChooser> {

  @override
  void initState() {
    super.initState();
    widget.dateController.date = widget.date;
  }

  Widget generateSelector(
      {String initialValue, List<String> values, Function(String) onNewValue, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
              padding: EdgeInsets.only(right: 8.0, left: 5.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  icon: Container(
                    width: 20,
                    height: 20,
                    child: Material(
                      shape: CircleBorder(),
                      color: CarlTheme.of(context).accentColor,
                      child: Icon(
                        Icons.expand_more,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  value: initialValue,
                  onChanged: (newValue) {
                    onNewValue(newValue);
                  },
                  items: values.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          style: CarlTheme.of(context).blueSmallLabel,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        generateSelector(
            initialValue: "${widget.date.day}",
            values: [for (var i = 1; i < 32; i++) "$i"],
            onNewValue: (newValue) {
              setState(() {
                final newDate = DateTime(widget.date.year, widget.date.month, int.parse(newValue));
                this.widget.date = newDate;
                this.widget.dateController.date = newDate;
              });
            }),
        generateSelector(
            initialValue: "${Localization.of(context).getMonths[this.widget.date.month - 1]}",
            values: Localization.of(context).getMonths,
            flex: 2,
            onNewValue: (newValue) {
              final index = Localization.of(context).getMonths.indexOf(newValue);
              setState(() {
                final newDate = DateTime(widget.date.year, index + 1, widget.date.day);
                this.widget.date = newDate;
                this.widget.dateController.date = newDate;
              });
            }),
        generateSelector(
            initialValue: "${widget.date.year}",
            values: [for (var i = 1900; i < 2020; i++) "$i"],
            onNewValue: (newValue) {
              setState(() {
                final newDate = DateTime(int.parse(newValue), widget.date.month, widget.date.day);
                this.widget.date = newDate;
                this.widget.dateController.date = newDate;
              });
            })
      ],
    );
  }
}
