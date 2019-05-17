import 'package:carl/models/business/visit.dart';
import 'package:equatable/equatable.dart';

abstract class VisitsState extends Equatable {
  VisitsState([List props = const []]) : super(props);
}

class VisitsLoading extends VisitsState {
  @override
  String toString() => 'VisitsLoading';
}

class VisitsLoadingSuccess extends VisitsState {
  VisitsLoadingSuccess({this.visits});

  final List<Visit> visits;

  @override
  String toString() => 'VisitsLoadingSuccess { visits = $visits }';
}

class VisitsLoadingError extends VisitsState {
  final bool isNetworkError;

  VisitsLoadingError({this.isNetworkError});

  @override
  String toString() => 'VisitsLoadingError { isNetworkError: $isNetworkError}';
}
