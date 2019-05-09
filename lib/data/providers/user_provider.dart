import 'package:carl/models/business_card.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/tokens_response.dart';
import 'package:flutter/widgets.dart';

abstract class UserProvider {
  Future<TokensResponse> authenticate({
    @required String username,
    @required String password,
  });

  Future<TokensResponse> register({@required RegistrationModel registrationModel});

  Future<void> deleteToken();

  Future<void> persistTokens(String accessToken, String refreshToken, int expiresIn);

  Future<bool> hasToken();

  Future<List<BusinessCard>> retrieveCards();
}
