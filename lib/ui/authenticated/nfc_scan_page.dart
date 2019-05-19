import 'package:carl/localization/localization.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/loader.dart';
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
  bool hasPermissionsBeenDenied = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    cameras = await availableCameras();

    controller = new QRReaderController(cameras[0], ResolutionPreset.medium, [CodeFormat.qr],
        (dynamic value) {
      _detectingQrCode(value);
      new Future.delayed(const Duration(seconds: 3), controller.startScanning);
    });
    // Fake delay to let the page load smoothly
    await Future.delayed(Duration(seconds: 2));
    _initializeReader();
  }

  _initializeReader() {
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        hasPermissionsBeenDenied = false;
      });
      controller.startScanning();
    }).catchError((error) {
      print("permission denied : $error");
      setState(() {
        hasPermissionsBeenDenied = true;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _renderPermissionAskButton() {
    return hasPermissionsBeenDenied
        ? Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              CarlButton(
                text: Localization.of(context).activate,
                onPressed: () {
                  setState(() {
                    hasPermissionsBeenDenied = true;
                  });
                  _initializeReader();
                },
                width: MediaQuery.of(context).size.width * .2,
              ),
            ],
          )
        : SizedBox();
  }

  void _detectingQrCode(String value) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                color: Colors.white,
                height: 200,
                width: 200,
                child:
                    Center(child: Text(value, style: CarlTheme.of(context).blackMediumBoldLabel)),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final scannerSize = MediaQuery.of(context).size.width * .8;

    var centerWidget = Container(
      height: scannerSize,
      width: scannerSize,
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent, width: 10)),
      child: QRReaderPreview(controller),
    );
    if (controller == null || !controller.value.isInitialized) {
      centerWidget = Container(
        height: scannerSize,
        width: scannerSize,
        decoration: BoxDecoration(
            color: Colors.transparent, border: Border.all(color: Colors.transparent, width: 10)),
        child: Center(
          child: this.hasPermissionsBeenDenied
              ? Text(
                  "Camera is Needed to scan code",
                  style: CarlTheme.of(context).blackMediumLabel,
                )
              : Loader(),
        ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          centerWidget,
                          Container(
                            height: scannerSize,
                            width: scannerSize,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: CarlTheme.of(context).scannerBlackBorder, width: 15)),
                          ),
                        ],
                      ),
                      _renderPermissionAskButton()
                    ],
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
