import 'dart:async';

import 'package:carl/data/providers/user_provider.dart';
import 'package:carl/models/black_listed.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:carl/models/business/business_card_detail.dart';
import 'package:carl/models/business/visit.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/IsBlackListedResponse.dart';
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

  Future<TokensResponse> register({@required RegistrationModel registrationModel}) {
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

  Future<void> updateNotificationsToken(String notificationsToken) {
    return userProvider.updateNotificationsToken(notificationsToken);
  }

  Future<List<BusinessCard>> retrieveCards() {
    return userProvider.retrieveCards();
  }

  Future<List<BlackListed>> retrieveBlackListedBusinesses() {
    return userProvider.retrieveBlackListedBusinesses();
  }

  Future<BusinessCardDetail> retrieveCardById(int cardId) {
    return userProvider.retrieveCardById(cardId);
  }

  Future<IsBlackListedResponse> isBusinessBlackListed(int businessId) {
    return userProvider.isBusinessBlackListed(businessId);
  }

  Future<IsBlackListedResponse> toggleBlackList(int businessId) {
    return userProvider.toggleBlackList(businessId);
  }

  Future<List<Visit>> retrieveVisits(int businessId, int fetchLimit, {DateTime lastFetchedDate}) {
    return userProvider.retrieveVisits(businessId, fetchLimit, lastFetchedDate: lastFetchedDate);
  }
}
