import 'package:equatable/equatable.dart';

abstract class VisitsEvent extends Equatable {
  VisitsEvent([List props = const []]) : super(props);
}

class RetrieveVisitsEvent extends VisitsEvent {
  final int businessId;
  final int fetchLimit;
  final DateTime lastFetchedDate;

  RetrieveVisitsEvent(this.businessId, this.fetchLimit, {this.lastFetchedDate});

  @override
  String toString() => 'RetrieveVisitsEvent';
}
