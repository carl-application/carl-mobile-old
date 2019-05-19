import 'package:equatable/equatable.dart';

abstract class ScannerEvent extends Equatable {
  ScannerEvent([List props = const []]) : super(props);
}

class ScanVisitEvent extends ScannerEvent {
  final String businessKey;

  ScanVisitEvent({this.businessKey});

  @override
  String toString() => 'ScanVisitEvent { businessKey: $businessKey }';
}
