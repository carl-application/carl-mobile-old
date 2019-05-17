import 'package:equatable/equatable.dart';

abstract class UnreadNotificationsState extends Equatable {
  UnreadNotificationsState([List props = const []]) : super(props);
}

class UnreadNotificationsInitialState extends UnreadNotificationsState {
  @override
  String toString() => 'UnreadNotificationsInitialState';
}

class RetrieveUnreadNotificationsSuccess extends UnreadNotificationsState {
  RetrieveUnreadNotificationsSuccess({this.unreadNotificationsCount});

  final int unreadNotificationsCount;

  @override
  String toString() =>
      'RetrieveUnreadNotificationsSuccess { unreadNotificationsCount: $unreadNotificationsCount }';
}

class RefreshUnreadNotificationsSuccess extends UnreadNotificationsState {
  RefreshUnreadNotificationsSuccess({this.unreadNotificationsCount});

  final int unreadNotificationsCount;

  @override
  String toString() =>
      'RefreshUnreadNotificationsSuccess { unreadNotificationsCount: $unreadNotificationsCount }';
}

class OnNewUnreadNotificationsState extends UnreadNotificationsState {
  OnNewUnreadNotificationsState({this.count});

  final int count;

  @override
  String toString() => 'OnNewUnreadNotificationsState { count: $count }';
}

class OnRemovedUnreadNotificationsState extends UnreadNotificationsState {
  OnRemovedUnreadNotificationsState();

  @override
  String toString() => 'OnRemovedUnreadNotificationsState}';
}

class RetrieveUnreadNotificationsError extends UnreadNotificationsState {
  @override
  String toString() => 'RetrieveUnreadNotificationsError';
}
