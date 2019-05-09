import 'package:carl/models/business_card.dart';
import 'package:equatable/equatable.dart';

abstract class CardsState extends Equatable {
  CardsState([List props = const []]) : super(props);
}

class CardsLoading extends CardsState {
  @override
  String toString() => 'CardsLoadingState';
}

class CardsLoadingSuccess extends CardsState {
  CardsLoadingSuccess({this.cards});

  final List<BusinessCard> cards;

  @override
  String toString() => 'CardsLoadingSuccess';
}

class CardsLoadingError extends CardsState {
  @override
  String toString() => 'CardsLoadingError';
}
