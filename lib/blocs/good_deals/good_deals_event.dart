import 'package:equatable/equatable.dart';

abstract class GoodDealsEvent extends Equatable {
  GoodDealsEvent([List props = const []]) : super(props);
}

class RetrieveGoodDealsEvent extends GoodDealsEvent {
  @override
  String toString() => 'RetrieveGoodDealsEvent';
}
