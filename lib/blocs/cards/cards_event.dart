import 'package:equatable/equatable.dart';

abstract class CardsEvent extends Equatable {
  CardsEvent([List props = const []]) : super(props);
}

class RetrieveCardsEvent extends CardsEvent {
  @override
  String toString() => 'RetrieveCardsEvent';
}
