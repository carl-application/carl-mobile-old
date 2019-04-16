import 'package:carl/blocs/authentication/authentication_bloc.dart';
import 'package:carl/blocs/authentication/authentication_event.dart';
import 'package:carl/blocs/authentication/authentication_state.dart';
import 'package:carl/blocs/user_registration/user_registration_bloc.dart';
import 'package:carl/blocs/user_registration/user_registration_event.dart';
import 'package:carl/blocs/user_registration/user_registration_state.dart';
import 'package:carl/data/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

void main() {
  UserRegistrationBloc registrationBloc;
  MockUserRepository userRepository;
  MockAuthenticationBloc authenticationBloc;

  setUp(() {
    userRepository = MockUserRepository();
    authenticationBloc = MockAuthenticationBloc();
    registrationBloc = UserRegistrationBloc(userRepository, authenticationBloc);
  });

  test('initial state is correct', () {
    expect(registrationBloc.initialState, RegistrationNotStarted());
  });

  test('dispose does not emit new states', () {
    expectLater(
      registrationBloc.state,
      emitsInOrder([RegistrationNotStarted()]),
    );
    registrationBloc.dispose();
  });

  group('Registration started', () {
    test('emits [notStarted, started] when asking for registration', () {
      final expectedResponse = [
        RegistrationNotStarted(),
        RegistrationStarted()
      ];

      expectLater(
        registrationBloc.state,
        emitsInOrder(expectedResponse),
      );

      registrationBloc.dispatch(StartRegistrationEvent());
    });
  });

  group('Setting userName', () {
    test(
        'emits [notStarted, started, userNameSet] when username has been set',
        () {
      final expectedResponse = [
        RegistrationNotStarted(),
        RegistrationStarted(),
        UserNameSet(userName: "toto"),
      ];

      expectLater(
        registrationBloc.state,
        emitsInOrder(expectedResponse),
      );

      registrationBloc.dispatch(StartRegistrationEvent());
      registrationBloc.dispatch(SetUsernameEvent(userName: "toto"));
    });
  });
}
