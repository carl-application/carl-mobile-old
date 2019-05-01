import 'package:equatable/equatable.dart';

abstract class UserRegistrationState extends Equatable {
  UserRegistrationState([List props = const []]) : super(props);
}

class RegistrationNotStarted extends UserRegistrationState {
  @override
  String toString() => 'RegistrationNotStarted';
}

class RegistrationLoading extends UserRegistrationState {
  @override
  String toString() => 'RegistrationLoading';
}

class RegistrationSucceed extends UserRegistrationState {
  @override
  String toString() => 'RegistrationSucceed';
}

class RegistrationFailed extends UserRegistrationState {
  final Exception error;

  RegistrationFailed(this.error);

  @override
  String toString() => 'RegistrationFailed { error: $error}';
}
