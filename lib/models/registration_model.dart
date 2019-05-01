import 'dart:core';

class RegistrationModel {
  final String userName;
  final String pseudo;
  final String password;
  final String sex;
  final String birthdayDate;

  RegistrationModel({this.pseudo, this.password, this.sex, this.birthdayDate, this.userName});

  Map<String, dynamic> toMap() {
    return {
      "username": userName,
      "password": password,
      "user": {
        "sex": sex,
        "birthDate": birthdayDate,
        "pseudo": pseudo,
      }
    };
  }
}
