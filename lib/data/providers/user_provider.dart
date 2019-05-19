import 'package:carl/models/black_listed.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:carl/models/business/business_card_detail.dart';
import 'package:carl/models/business/business_image.dart';
import 'package:carl/models/business/visit.dart';
import 'package:carl/models/good_deal.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/IsBlackListedResponse.dart';
import 'package:carl/models/responses/scan_visit_response.dart';
import 'package:carl/models/responses/tokens_response.dart';
import 'package:carl/models/responses/unread_notifications_count_response.dart';
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

  Future<BusinessImage> getImageById(int id);

  Future<List<BlackListed>> retrieveBlackListedBusinesses();

  Future<BusinessCardDetail> retrieveCardById(int cardId);

  Future<UnreadNotificationsResponse> retrieveUnreadNotificationsCount();

  Future<IsBlackListedResponse> isBusinessBlackListed(int businessId);

  Future<IsBlackListedResponse> toggleBlackList(int businessId);

  Future<List<Visit>> retrieveVisits(int businessId, int fetchLimit, {DateTime lastFetchedDate});

  Future<List<GoodDeal>> retrieveUnreadGoodDeals();

  Future<List<GoodDeal>> retrieveReadGoodDeals();

  Future<GoodDeal> retrievedGoodDealDetail(int id);

  Future<ScanVisitResponse> scanVisit(String businessKey);
}
