import 'package:carl/blocs/scanner/scanner_bloc.dart';
import 'package:carl/blocs/scanner/scanner_event.dart';
import 'package:carl/blocs/scanner/scanner_state.dart';
import 'package:carl/data/repository_dealer.dart';
import 'package:carl/localization/localization.dart';
import 'package:carl/models/navigation_arguments/card_detail_arguments.dart';
import 'package:carl/models/navigation_arguments/scan_nfc_arguments.dart';
import 'package:carl/ui/shared/carl_button.dart';
import 'package:carl/ui/shared/clickable_text.dart';
import 'package:carl/ui/shared/error_api_call.dart';
import 'package:carl/ui/shared/loader.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_ink_well/image_ink_well.dart';

import '../theme.dart';
import 'card_detail_page.dart';
import 'card_percent_indicator_painter.dart';
import 'empty_element.dart';

class ScanPage extends StatefulWidget {
  static const String routeName = "/scanPage";

  final CallSource source;

  const ScanPage({Key key, this.source}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  List<CameraDescription> cameras;
  QRReaderController controller;
  bool hasPermissionsBeenDenied = false;
  ScannerBloc _scannerBloc;

  _navigateToCardDetail(BuildContext context, int businessId) {
    Navigator.of(context).pop();
    if (widget.source == CallSource.home) {
      Navigator.of(context).pushReplacementNamed(CardDetailPage.routeName,
          arguments: CardDetailArguments(businessId));
    }
  }

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
    _scannerBloc?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _scannerBloc = ScannerBloc(RepositoryDealer.of(context).userRepository);
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
    _scannerBloc.dispatch(ScanVisitEvent(businessKey: value));
    final double percentIndicatorSize = MediaQuery.of(context).size.width * .2;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      color: CarlTheme.of(context).background,
                      borderRadius: BorderRadius.circular(20.0)),
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: BlocBuilder<ScannerEvent, ScannerState>(
                      bloc: _scannerBloc,
                      builder: (BuildContext context, ScannerState state) {
                        if (state is ScannerLoading || state is ScannerInitialState) {
                          return Center(
                            child: Loader(),
                          );
                        } else if (state is ScannerSuccess) {
                          final scanResponse = state.scanVisitResponse;
                          final businessDetail = state.businessCardDetail;
                          final userCount =
                              scanResponse.userVisitsCount % scanResponse.businessVisitsMax == 0
                                  ? scanResponse.businessVisitsMax
                                  : (scanResponse.userVisitsCount % scanResponse.businessVisitsMax);
                          return Stack(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          businessDetail.business.businessName,
                                          style: CarlTheme.of(context).blackTitle,
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: <Widget>[
                                              Center(
                                                child: Container(
                                                  width: percentIndicatorSize,
                                                  height: percentIndicatorSize,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle, color: Colors.white),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: CustomPaint(
                                                      foregroundPainter:
                                                          CardPercentIndicatorPainter(
                                                              lineColor: Colors.transparent,
                                                              completeColor: CarlTheme.of(context)
                                                                  .percentIndicatorCompleteColor,
                                                              completePercent: userCount /
                                                                  scanResponse.businessVisitsMax *
                                                                  100,
                                                              width: 10.0),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Text("$userCount",
                                                                style: CarlTheme.of(context)
                                                                    .blackBigNumber),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text("/",
                                                                style: CarlTheme.of(context)
                                                                    .blackMediumNumber),
                                                            Text(
                                                                "${scanResponse.businessVisitsMax}",
                                                                style: CarlTheme.of(context)
                                                                    .blackMediumNumber),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 20,
                                                right: 20,
                                                child: Container(
                                                  height: MediaQuery.of(context).size.width * .1,
                                                  width: MediaQuery.of(context).size.width * .1,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green, shape: BoxShape.circle),
                                                  child: Center(
                                                    child: Text(
                                                      "+ 1",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CarlButton(
                                    text: "Détails",
                                    onPressed: () =>
                                        _navigateToCardDetail(context, businessDetail.business.id),
                                    textStyle: CarlTheme.of(context).whiteBigLabel,
                                    color: CarlTheme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ClickableText(
                                    text: "ok",
                                    clickedColor: Colors.white,
                                    textStyle: CarlTheme.of(context).black12MediumLabel,
                                    onClick: () => Navigator.of(context).pop(),
                                  )
                                ],
                              ),
                            ],
                          );
                        } else if (state is ScannerError) {
                          var errorWidget;
                          if (state.isBusinessNotFoundError) {
                            errorWidget = EmptyElement(
                              assetImageUrl: "assets/empty_cards.png",
                              title: "Aucun business trouvé",
                              description: "Ce Qr code semble incorrect !",
                            );
                          } else {
                            errorWidget = ErrorApiCall(
                              errorTitle: state.isNetworkError
                                  ? Localization.of(context).networkErrorTitle
                                  : Localization.of(context).errorServerTitle,
                              errorDescription: state.isNetworkError
                                  ? Localization.of(context).networkErrorDescription
                                  : Localization.of(context).errorServerDescription,
                            );
                          }

                          return errorWidget;
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )));
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
                        onPressed: () => _detectingQrCode("533a6f1f-4d9b-4804-902a-3cd31abb14bf"),
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
