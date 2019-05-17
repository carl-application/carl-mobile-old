import 'package:carl/models/business/business_card_detail.dart';
import 'package:equatable/equatable.dart';

abstract class CardDetailState extends Equatable {
  CardDetailState([List props = const []]) : super(props);
}

class CardByIdLoading extends CardDetailState {
  @override
  String toString() => 'CardByIdLoading';
}

class CardByIdLoadingSuccess extends CardDetailState {
  CardByIdLoadingSuccess({this.card, this.isBlackListed});

  final BusinessCardDetail card;
  final bool isBlackListed;

  @override
  String toString() => 'CardByIdLoadingSuccess';
}

class CardByIdLoadingError extends CardDetailState {
  final bool isNetworkError;

  CardByIdLoadingError({this.isNetworkError});

  @override
  String toString() => 'CardByIdLoadingError { isNetworkError: $isNetworkError }';
}
