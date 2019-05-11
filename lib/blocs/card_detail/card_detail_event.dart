import 'package:equatable/equatable.dart';

abstract class CardDetailEvent extends Equatable {
  CardDetailEvent([List props = const []]) : super(props);
}

class RetrieveCardByIdEvent extends CardDetailEvent {
  final int cardId;

  RetrieveCardByIdEvent({this.cardId});

  @override
  String toString() => 'RetrieveCardByIdEvent';
}
