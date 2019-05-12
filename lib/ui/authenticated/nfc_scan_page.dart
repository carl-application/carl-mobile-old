import 'package:carl/models/navigation_arguments/card_detail_arguments.dart';
import 'package:carl/models/navigation_arguments/scan_nfc_arguments.dart';
import 'package:carl/ui/authenticated/card_detail_page.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';

class NfcScanPage extends StatefulWidget {
  static const routeName = "/NfcScanPage";

  CallSource source;

  @override
  _NfcScanPageState createState() => _NfcScanPageState();
}

class _NfcScanPageState extends State<NfcScanPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.source = ModalRoute.of(context).settings.arguments;
  }

  _navigateBack(BuildContext context) {
    if (widget.source == CallSource.home) {
      Navigator.of(context)
          .pushReplacementNamed(CardDetailPage.routeName, arguments: CardDetailArguments(1));
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CarlTheme.of(context).background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Scan NFC (from ${widget.source} screen)"),
              RaisedButton(
                onPressed: () => _navigateBack(context),
                child: Text("finished scanning"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
