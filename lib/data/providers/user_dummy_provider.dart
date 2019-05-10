import 'package:carl/data/providers/user_provider.dart';
import 'package:carl/models/business_card.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/tokens_response.dart';
import 'package:flutter/widgets.dart';

class UserDummyProvider implements UserProvider {
  final list = List<BusinessCard>();

  UserDummyProvider() {
    list.add(BusinessCard(
        0,
        "Midi Pile",
        "74 rue Chaptal, Levallois",
        "https://picsum.photos/id/200/200",
        "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png",
        [
          Tag(0, "Salade"),
          Tag(1, "Fraicheur"),
          Tag(2, "Bien-être"),
          Tag(3, "Boissons"),
          Tag(4, "Tomate"),
        ],
        8,
        10,
        "Une salade offerte pour 10 achetées !"));
    list.add(BusinessCard(
        1,
        "KFC",
        "30 rue du Bucket",
        "https://picsum.photos/id/201/200",
        "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png",
        [Tag(0, "poulet")],
        4,
        5,
        "Un bucket offert pour 5 achetés !"));

    list.add(BusinessCard(
        2,
        "Les fleurs du marché",
        "30 rue de la rose",
        "https://picsum.photos/id/202/200",
        "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png",
        [Tag(0, "fleurs")],
        13,
        15,
        "Le bouquer offert pour 15 achats"));
    list.add(BusinessCard(
        3,
        "La boulangerie du coin",
        "30 rue de la broche",
        "https://picsum.photos/id/203/200",
        "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png",
        [Tag(0, "pain")],
        2,
        10,
        "Un menu midi offert pour 10 achetés"));
    list.add(BusinessCard(
        4,
        "Pizza Victoria",
        "80 rue de la tagliatelle",
        "https://picsum.photos/id/204/200",
        "https://cdn.pixabay.com/photo/2018/09/24/11/11/coffee-3699657_1280.png",
        [Tag(0, "pizza")],
        1,
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
  Future<BusinessCard> retrieveCardById(int cardId) async {
    await Future.delayed(Duration(seconds: 1));
    return list.firstWhere((businessCard) => businessCard.id == cardId);
  }
}
