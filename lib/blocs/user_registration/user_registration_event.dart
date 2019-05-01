import 'package:carl/models/registration_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserRegistrationEvent extends Equatable {
  UserRegistrationEvent([List props = const []]) : super(props);
}

class RegisterUserEvent extends UserRegistrationEvent {
  final RegistrationModel registrationModel;

  RegisterUserEvent({@required this.registrationModel}) : super([registrationModel]);

  @override
  String toString() => 'RegisterUserEvent { registrationModel : $registrationModel }';
}
