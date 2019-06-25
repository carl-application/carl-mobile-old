import 'package:carl/models/responses/tokens_response.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  final TokensResponse tokens;

  LoggedIn({@required this.tokens}) : super([tokens]);

  @override
  String toString() => 'LoggedIn { token: $tokens }';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}

class DeleteAccount extends AuthenticationEvent {
  @override
  String toString() => 'DeleteAccount';
}
