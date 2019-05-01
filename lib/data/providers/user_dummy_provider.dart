import 'package:carl/data/providers/user_provider.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/tokens_response.dart';
import 'package:flutter/widgets.dart';

class UserDummyProvider implements UserProvider {
  @override
  Future<TokensResponse> authenticate({String username, String password}) async {
    await Future.delayed(Duration(seconds: 1));
    return TokensResponse();
  }

  @override
  Future<void> deleteToken() {
    return null;
  }

  @override
  Future<bool> hasToken() async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }

  @override
  Future<void> persistTokens(String accessToken, String refreshToken, int expiresIn) async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }

  @override
  Future<TokensResponse> register({@required RegistrationModel registrationModel}) async {
    return TokensResponse();
  }
}
