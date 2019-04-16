import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserRegistrationEvent extends Equatable {
  UserRegistrationEvent([List props = const []]) : super(props);
}

class StartRegistrationEvent extends UserRegistrationEvent {
  @override
  String toString() => 'StartRegistrationEvent';
}

class SetUsernameEvent extends UserRegistrationEvent {
  final String userName;

  SetUsernameEvent({@required this.userName}) : super([userName]);

  @override
  String toString() => 'SetUsernameEvent { userName: $userName }';
}
