import 'package:equatable/equatable.dart';

abstract class GoodDealDetailEvent extends Equatable {
  GoodDealDetailEvent([List props = const []]) : super(props);
}

class RetrieveGoodDealByIdEvent extends GoodDealDetailEvent {
  final int id;

  RetrieveGoodDealByIdEvent({this.id});

  @override
  String toString() => 'RetrieveGoodDealByIdEvent { id: $id }';
}
