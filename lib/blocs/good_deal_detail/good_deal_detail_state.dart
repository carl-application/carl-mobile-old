import 'package:carl/models/good_deal.dart';
import 'package:equatable/equatable.dart';

abstract class GoodDealDetailState extends Equatable {
  GoodDealDetailState([List props = const []]) : super(props);
}

class GoodDealByIdLoading extends GoodDealDetailState {
  @override
  String toString() => 'GoodDealByIdLoading';
}

class GoodDealByIdLoadingSuccess extends GoodDealDetailState {
  GoodDealByIdLoadingSuccess({this.goodDeal});

  final GoodDeal goodDeal;

  @override
  String toString() => 'GoodDealByIdLoadingSuccess { goodDeal: $goodDeal }';
}

class GoodDealByIdLoadingError extends GoodDealDetailState {
  @override
  String toString() => 'GoodDealByIdLoadingError';
}
