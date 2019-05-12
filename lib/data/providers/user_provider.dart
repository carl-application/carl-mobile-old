import 'package:carl/models/black_listed.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:carl/models/business/business_card_detail.dart';
import 'package:carl/models/business/visit.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/IsBlackListedResponse.dart';
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

  Future<void> updateNotificationsToken(String notificationsToken);

  Future<List<BusinessCard>> retrieveCards();

  Future<List<BlackListed>> retrieveBlackListedBusinesses();

  Future<BusinessCardDetail> retrieveCardById(int cardId);

  Future<IsBlackListedResponse> isBusinessBlackListed(int businessId);

  Future<IsBlackListedResponse> toggleBlackList(int businessId);

  Future<List<Visit>> retrieveVisits(int businessId, int fetchLimit, {DateTime lastFetchedDate});
}
