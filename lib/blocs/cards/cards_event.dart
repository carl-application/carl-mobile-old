import 'package:equatable/equatable.dart';

abstract class CardsEvent extends Equatable {
  CardsEvent([List props = const []]) : super(props);
}

class RetrieveCardsEvent extends CardsEvent {
  @override
  String toString() => 'RetrieveCardsEvent';
}

class RetrieveCardByIdEvent extends CardsEvent {
  final int cardId;

  RetrieveCardByIdEvent({this.cardId});

  @override
  String toString() => 'RetrieveCardByIdEvent';
}
