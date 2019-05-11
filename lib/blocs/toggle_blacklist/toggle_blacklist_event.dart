import 'package:equatable/equatable.dart';

abstract class ToggleBlacklistEvent extends Equatable {
  ToggleBlacklistEvent([List props = const []]) : super(props);
}

class ToggleNotificationBlackListEvent extends ToggleBlacklistEvent {
  final int cardId;

  ToggleNotificationBlackListEvent({this.cardId});

  @override
  String toString() => 'ToggleNotificationBlackListEvent';
}
