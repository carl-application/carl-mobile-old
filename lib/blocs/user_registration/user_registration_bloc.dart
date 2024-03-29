import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/authentication/authentication_event.dart';
import 'package:carl/blocs/user_registration/user_registration_event.dart';
import 'package:carl/blocs/user_registration/user_registration_state.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:carl/models/exceptions/email_already_exist_exception.dart';

class UserRegistrationBloc extends Bloc<UserRegistrationEvent, UserRegistrationState> {
  UserRegistrationBloc(this._userRepository, this._authenticationBloc);

  final UserRepository _userRepository;
  final AuthenticationBloc _authenticationBloc;
  bool _isEmailAlreadyUsed = false;

  get isEmailAlreadyUsed => _isEmailAlreadyUsed;

  @override
  UserRegistrationState get initialState => RegistrationNotStarted();

  @override
  Stream<UserRegistrationState> mapEventToState(
    UserRegistrationEvent event,
  ) async* {
    if (event is RegisterUserEvent) {
      yield RegistrationLoading();

      try {
        final tokens = await _userRepository.register(registrationModel: event.registrationModel);

        _authenticationBloc.dispatch(LoggedIn(tokens: tokens));
      } catch (error) {
        yield RegistrationFailed(isEmailAlreadyInDatabase: error is EmailAlreadyExistException);
      }
    }
  }
}
