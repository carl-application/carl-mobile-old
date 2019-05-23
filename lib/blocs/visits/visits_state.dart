import 'package:carl/models/business/visit.dart';
import 'package:equatable/equatable.dart';

abstract class VisitsState {
  VisitsState([List props = const []]);
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

class LoadMoreSuccessState extends VisitsState {
  LoadMoreSuccessState({this.visits, this.hasReachedMax});

  final List<Visit> visits;
  final bool hasReachedMax;

  @override
  String toString() => 'LoadMoreSuccessState { visits: $visits, hasReachedMax: $hasReachedMax }';
}

class VisitsLoadingError extends VisitsState {
  final bool isNetworkError;

  VisitsLoadingError({this.isNetworkError});

  @override
  String toString() => 'VisitsLoadingError { isNetworkError: $isNetworkError}';
}
