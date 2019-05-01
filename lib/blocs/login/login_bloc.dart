import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/authentication/authentication_event.dart';
import 'package:carl/blocs/login/login_event.dart';
import 'package:carl/blocs/login/login_state.dart';
import 'package:carl/data/repositories/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._userRepository, this._authenticationBloc);

  final UserRepository _userRepository;
  final AuthenticationBloc _authenticationBloc;

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final tokens = await _userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        _authenticationBloc.dispatch(LoggedIn(tokens: tokens));
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
