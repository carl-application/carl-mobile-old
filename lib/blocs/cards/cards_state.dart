import 'package:carl/models/black_listed.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:equatable/equatable.dart';

abstract class CardsState extends Equatable {
  CardsState([List props = const []]) : super(props);
}

class CardsLoading extends CardsState {
  @override
  String toString() => 'CardsLoadingState';
}

class CardsLoadingSuccess extends CardsState {
  CardsLoadingSuccess({this.cards, this.blackListedBusinesses});

  final List<BusinessCard> cards;
  final List<BlackListed> blackListedBusinesses;

  @override
  String toString() => 'CardsLoadingSuccess';
}

class CardsLoadingError extends CardsState {
  final bool isNetworkError;

  CardsLoadingError({this.isNetworkError});

  @override
  String toString() => 'CardsLoadingError { isNetworkError: $isNetworkError ';
}
