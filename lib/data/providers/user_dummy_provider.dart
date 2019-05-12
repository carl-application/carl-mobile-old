import 'package:carl/data/providers/user_provider.dart';
import 'package:carl/models/black_listed.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:carl/models/business/business_card_detail.dart';
import 'package:carl/models/business/business_image.dart';
import 'package:carl/models/business/business_tag.dart';
import 'package:carl/models/business/visit.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/IsBlackListedResponse.dart';
import 'package:carl/models/responses/tokens_response.dart';
import 'package:flutter/widgets.dart';

class UserDummyProvider implements UserProvider {
  final list = List<BusinessCard>();
  var isBlackListed = false;

  UserDummyProvider() {
    list.add(BusinessCard(
        0,
        "Midi Pile",
        "74 rue Chaptal, Levallois",
        BusinessImage(0, "https://picsum.photos/id/200/200"),
        BusinessImage(0, "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png"),
        [
          Tag(0, "Salade"),
          Tag(1, "Fraicheur"),
          Tag(2, "Bien-être"),
          Tag(3, "Boissons"),
          Tag(4, "Tomate"),
        ],
        10,
        "Une salade offerte pour 10 achetées !"));
    list.add(BusinessCard(
        1,
        "KFC",
        "30 rue du Bucket",
        BusinessImage(0, "https://picsum.photos/id/201/200"),
        BusinessImage(0, "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png"),
        [Tag(0, "poulet")],
        5,
        "Un bucket offert pour 5 achetés !"));

    list.add(BusinessCard(
        2,
        "Les fleurs du marché",
        "30 rue de la rose",
        BusinessImage(0, "https://picsum.photos/id/202/200"),
        BusinessImage(0, "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png"),
        [Tag(0, "fleurs")],
        15,
        "Le bouquer offert pour 15 achats"));
    list.add(BusinessCard(
        3,
        "La boulangerie du coin",
        "30 rue de la broche",
        BusinessImage(0, "https://picsum.photos/id/203/200"),
        BusinessImage(0, "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png"),
        [Tag(0, "pain")],
        10,
        "Un menu midi offert pour 10 achetés"));
    list.add(BusinessCard(
        4,
        "Pizza Victoria",
        "80 rue de la tagliatelle",
        BusinessImage(0, "https://picsum.photos/id/204/200"),
        BusinessImage(0, "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png"),
        [Tag(0, "pizza")],
        5,
        "La pizza maxi offerte pour l'achat de 5 pizzas, c'est vraiment une affaire à pas louper moi je vous le dis wallah je fais un message super loooooooooooooooong !"));
  }

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
    await Future.delayed(Duration(milliseconds: 300));
    return false;
  }

  @override
  Future<void> updateNotificationsToken(String notificationsToken) async {
    await Future.delayed(Duration(seconds: 1));
    return false;
  }

  @override
  Future<void> persistTokens(String accessToken, String refreshToken, int expiresIn) async {
    /// read from keystore/keychain
    await Future.delayed(Duration(milliseconds: 300));
    return false;
  }

  @override
  Future<TokensResponse> register({@required RegistrationModel registrationModel}) async {
    return TokensResponse();
  }

  @override
  Future<List<BusinessCard>> retrieveCards() async {
    await Future.delayed(Duration(seconds: 2));

    return list;
  }

  @override
  Future<BusinessCardDetail> retrieveCardById(int cardId) async {
    await Future.delayed(Duration(seconds: 1));
    final businessCard = list.firstWhere((businessCard) => businessCard.id == cardId);

    return BusinessCardDetail(cardId + 1, businessCard);
  }

  @override
  Future<List<Visit>> retrieveVisits(int businessId, int fetchLimit,
      {DateTime lastFetchedDate}) async {
    await Future.delayed(Duration(seconds: 1));
    final List<Visit> list = List();
    list.add(Visit(0, DateTime.utc(2019, 5, 11, 9, 20)));
    list.add(Visit(0, DateTime.utc(2019, 4, 11, 9, 20)));
    return list;
  }

  @override
  Future<List<BlackListed>> retrieveBlackListedBusinesses() async {
    await Future.delayed(Duration(milliseconds: 500));
    final List<BlackListed> list = List();
    list.add(BlackListed(0, BlackListedBusiness(0)));

    return list;
  }

  @override
  Future<IsBlackListedResponse> isBusinessBlackListed(int businessId) async {
    await Future.delayed(Duration(seconds: 1));
    return IsBlackListedResponse(isBlackListed: isBlackListed);
  }

  @override
  Future<IsBlackListedResponse> toggleBlackList(int businessId) async {
    await Future.delayed(Duration(seconds: 1));
    isBlackListed = !isBlackListed;
    return IsBlackListedResponse(isBlackListed: isBlackListed);
  }
}
