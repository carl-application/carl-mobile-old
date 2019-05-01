import 'dart:async';

import 'package:carl/data/providers/user_provider.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/tokens_response.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final UserProvider userProvider;

  UserRepository({this.userProvider});

  Future<TokensResponse> authenticate({
    @required String username,
    @required String password,
  }) {
    return userProvider.authenticate(username: username, password: password);
  }

  Future<TokensResponse> register(
      {@required RegistrationModel registrationModel}) {
    return userProvider.register(registrationModel: registrationModel);
  }

  Future<void> deleteToken() {
    return userProvider.deleteToken();
  }

  Future<void> persistTokens(String accessToken, String refreshToken, int expiresIn) {
    return userProvider.persistTokens(accessToken, refreshToken, expiresIn);
  }

  Future<bool> hasToken() {
    return userProvider.hasToken();
  }
}
