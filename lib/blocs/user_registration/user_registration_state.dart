import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class UserRegistrationState extends Equatable {
  UserRegistrationState([List props = const []]) : super(props);
}

class RegistrationNotStarted extends UserRegistrationState {
  @override
  String toString() => 'RegistrationNotStarted';
}

class RegistrationStarted extends UserRegistrationState {
  @override
  String toString() => 'RegistrationStarted';
}

class UserNameSet extends UserRegistrationState {
  final String userName;

  UserNameSet({@required this.userName}) : super([userName]);

  @override
  String toString() => 'UserNameSet { userName: $userName }';
}
