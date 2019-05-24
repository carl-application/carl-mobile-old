import 'package:carl/models/business/business_card.dart';

abstract class SearchBusinessesState {
  SearchBusinessesState([List props = const []]);
}

class SearchBusinessesLoading extends SearchBusinessesState {
  @override
  String toString() => 'SearchBusinessesLoading';
}

class SearchBusinessesLoadingSuccess extends SearchBusinessesState {
  SearchBusinessesLoadingSuccess({this.businesses});

  final List<BusinessCard> businesses;

  @override
  String toString() => 'SearchBusinessesLoadingSuccess {businesses: $businesses}';
}

class SearchBusinessesLoadingError extends SearchBusinessesState {
  final bool isNetworkError;

  SearchBusinessesLoadingError({this.isNetworkError});

  @override
  String toString() => 'SearchBusinessesLoadingError { isNetworkError: $isNetworkError }';
}
