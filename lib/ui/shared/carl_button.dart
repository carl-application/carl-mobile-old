import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CarlButton extends StatelessWidget {
  CarlButton({@required this.text, @required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      elevation: 10,
      padding: EdgeInsets.only(top: 20, right: 30, bottom: 20, left: 30),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Center(child: Text(
            text,
            style: TextStyle(color: Theme.of(context).primaryColor),
        )),
      ),
      onPressed: () {
        this.onPressed();
      },
    );
  }
}
