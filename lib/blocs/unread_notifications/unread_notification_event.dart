import 'package:equatable/equatable.dart';

abstract class UnreadNotificationsEvent extends Equatable {
  UnreadNotificationsEvent([List props = const []]) : super(props);
}

class RetrieveUnreadNotificationsCountEvent extends UnreadNotificationsEvent {
  @override
  String toString() => 'RetrieveUnreadNotificationsCountEvent';
}

class RefreshUnreadNotificationsCountEvent extends UnreadNotificationsEvent {
  @override
  String toString() => 'RefreshUnreadNotificationsCountEvent';
}

class AddNewUnreadNotificationsEvent extends UnreadNotificationsEvent {
  final int count;

  AddNewUnreadNotificationsEvent(this.count);

  @override
  String toString() => 'AddNewUnreadNotificationsEvent { count: $count}';
}

class RemoveOneUnreadNotificationsEvent extends UnreadNotificationsEvent {
  RemoveOneUnreadNotificationsEvent();

  @override
  String toString() => 'RemoveOneUnreadNotificationsEvent}';
}
