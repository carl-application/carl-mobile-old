import 'package:carl/data/providers/user_provider.dart';
import 'package:carl/models/business_card.dart';
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
    return true;
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

  @override
  Future<List<BusinessCard>> retrieveCards() async {
    await Future.delayed(Duration(seconds: 2));
    final list = List<BusinessCard>();
    list.add(BusinessCard("Midi Pile", "74 rue Chaptal, Levallois", "https://picsum.photos/id/200/200"));
    list.add(BusinessCard("KFC", "30 rue du Bucket", "https://picsum.photos/id/201/200"));
    list.add(BusinessCard("Les fleurs du marché", "30 rue de la rose", "https://picsum.photos/id/202/200"));
    list.add(BusinessCard("La boulangerie du coin", "30 rue de la broche", "https://picsum.photos/id/203/200"));
    list.add(BusinessCard("Pizza Victoria", "80 rue de la tagliatelle", "https://picsum.photos/id/204/200"));

    return list;
  }
}
