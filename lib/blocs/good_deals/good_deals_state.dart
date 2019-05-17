import 'package:carl/models/good_deal.dart';
import 'package:equatable/equatable.dart';

abstract class GoodDealsState extends Equatable {
  GoodDealsState([List props = const []]) : super(props);
}

class GoodDealsLoading extends GoodDealsState {
  @override
  String toString() => 'GoodDealsLoading';
}

class GoodDealsLoadingSuccess extends GoodDealsState {
  GoodDealsLoadingSuccess({this.goodDeals});

  final List<GoodDeal> goodDeals;

  @override
  String toString() => 'GoodDealsLoadingSuccess {goodDeals: $goodDeals}';
}

class GoodDealsLoadingError extends GoodDealsState {
  final bool isNetworkError;

  GoodDealsLoadingError({this.isNetworkError});

  @override
  String toString() => 'GoodDealsLoadingError { isNetworkError: $isNetworkError }';
}
