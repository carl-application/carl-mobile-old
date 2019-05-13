import 'package:carl/models/navigation_arguments/card_detail_arguments.dart';
import 'package:carl/models/navigation_arguments/scan_nfc_arguments.dart';
import 'package:carl/ui/authenticated/card_detail_page.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class NfcScanPage extends StatefulWidget {
  static const routeName = "/NfcScanPage";

  CallSource source;

  @override
  _NfcScanPageState createState() => _NfcScanPageState();
}

class _NfcScanPageState extends State<NfcScanPage> {
  NfcData _nfcData;
  String _infos;

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

  Future<void> startNFC() async {
    setState(() {
      _nfcData = NfcData();
      _nfcData.status = NFCStatus.reading;
      _infos = "NFC: Scan started";
    });

    FlutterNfcReader.read.listen((response) {
      setState(() {
        _nfcData = response;
        _infos = "NFC: ${response.content}";
      });
    });
  }

  Future<void> stopNFC() async {
    NfcData response;

    try {
      print('NFC: Stop scan by user');
      response = await FlutterNfcReader.stop;
    } on PlatformException {
      print('NFC: Stop scan exception');
      response = NfcData(
        id: '',
        content: '',
        error: 'NFC scan stop exception',
        statusMapper: '',
      );
      response.status = NFCStatus.error;
    }

    setState(() {
      _nfcData = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CarlTheme.of(context).background,
        child: Center(
          child: FutureBuilder(
            future: startNFC(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Scan NFC (from ${widget.source} screen)"),
                  Text(_infos),
                  RaisedButton(
                    onPressed: () => _navigateBack(context),
                    child: Text("finished scanning"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
