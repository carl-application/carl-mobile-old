import 'package:carl/models/business/business_card_detail.dart';
import 'package:carl/models/responses/scan_visit_response.dart';
import 'package:equatable/equatable.dart';

abstract class ScannerState extends Equatable {
  ScannerState([List props = const []]) : super(props);
}

class ScannerInitialState extends ScannerState {
  @override
  String toString() => 'ScannerInitialState';
}

class ScannerLoading extends ScannerState {
  @override
  String toString() => 'ScannerLoading';
}

class ScannerSuccess extends ScannerState {
  final ScanVisitResponse scanVisitResponse;
  final BusinessCardDetail businessCardDetail;

  ScannerSuccess({this.scanVisitResponse, this.businessCardDetail});

  @override
  String toString() => 'ScannerSuccess { scanVisitResponse: $scanVisitResponse }';
}

class ScannerError extends ScannerState {
  final bool isBusinessNotFoundError;
  final bool isNetworkError;
  final bool isScanLimitReached;

  ScannerError({this.isBusinessNotFoundError, this.isNetworkError, this.isScanLimitReached});

  @override
  String toString() => 'ScannerError';
}
