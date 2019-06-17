import 'package:equatable/equatable.dart';

abstract class GoodDealsEvent extends Equatable {
  GoodDealsEvent([List props = const []]) : super(props);
}

class RetrieveGoodDealsEvent extends GoodDealsEvent {
  @override
  String toString() => 'RetrieveGoodDealsEvent';
}

class HaveReadGoodDealEvent extends GoodDealsEvent {
  final int index;

  HaveReadGoodDealEvent(this.index);

  @override
  String toString() => 'HaveReadGoodDealEvent';
}
