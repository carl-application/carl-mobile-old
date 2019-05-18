import 'package:carl/localization/localization.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:image_ink_well/image_ink_well.dart';

import '../theme.dart';

class NfcScanPage extends StatefulWidget {
  static const String routeName = "/scanPage";

  @override
  _NfcScanPageState createState() => _NfcScanPageState();
}

class _NfcScanPageState extends State<NfcScanPage> {
  List<CameraDescription> cameras;
  QRReaderController controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    cameras = await availableCameras();
    controller = new QRReaderController(cameras[0], ResolutionPreset.medium, [CodeFormat.qr],
        (dynamic value) {
      print(value); // the result!
      // ... do something
      // wait 3 seconds then start scanning again.
      new Future.delayed(const Duration(seconds: 3), controller.startScanning);
    });
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      controller.startScanning();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scannerSize = MediaQuery.of(context).size.width * .8;
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: CarlTheme.of(context).background,
      );
    }
    return Scaffold(
      body: Container(
        color: CarlTheme.of(context).background,
        child: SafeArea(
          child: Padding(
            padding: CarlTheme.of(context).pagePadding,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      Localization.of(context).scanPageTitle,
                      style: CarlTheme.of(context).blackMediumBoldLabel,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: scannerSize,
                          width: scannerSize,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                              width: 10
                            )
                          ),
                          child: QRReaderPreview(controller),
                        ),
                        Container(
                          height: scannerSize,
                          width: scannerSize,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: CarlTheme.of(context).scannerBlackBorder, width: 15)),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      height: 50,
                      child: CircleImageInkWell(
                        onPressed: () => Navigator.of(context).pop(),
                        size: 50,
                        image: AssetImage('assets/ic_close.png'),
                        splashColor: Colors.black26,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
