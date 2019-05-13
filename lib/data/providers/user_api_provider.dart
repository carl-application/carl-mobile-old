import 'dart:convert';
import 'dart:io';

import 'package:carl/data/api/api.dart';
import 'package:carl/data/providers/user_provider.dart';
import 'package:carl/models/black_listed.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:carl/models/business/business_card_detail.dart';
import 'package:carl/models/business/business_image.dart';
import 'package:carl/models/business/visit.dart';
import 'package:carl/models/exceptions/bad_credentials_exception.dart';
import 'package:carl/models/exceptions/email_already_exist_exception.dart';
import 'package:carl/models/exceptions/server_exception.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/IsBlackListedResponse.dart';
import 'package:carl/models/responses/tokens_response.dart';
import 'package:carl/models/responses/unread_notifications_count_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const API_BASE_URL = "https://carl-api.herokuapp.com";
const API_REGISTRATION_URL = "$API_BASE_URL/register";
const API_REFRESH_TOKEN_URL = "$API_BASE_URL/auth/token";
const API_RETRIEVE_CARDS = "$API_BASE_URL/user/cards";
const API_RETRIEVE_VISITS = "$API_BASE_URL/user/visits";
const API_RETRIEVE_BLACKLISTED = "$API_BASE_URL/user/notifications/blacklist";
const API_RETRIEVE_IF_BUSINESS_IS_BLACKLISTED = "$API_BASE_URL/user/notifications/blacklist";
const API_TOGGLE_BLACKLISTED = "$API_BASE_URL/user/notifications/blacklist";
const API_LOGIN = "$API_BASE_URL/auth/token";
const API_USER_BUSINESS_META_INFO = "$API_BASE_URL/user/visits/info";
const API_UPDATE_NOTIFICATION_TOKEN = "$API_BASE_URL/user/notifications/token";
const API_GET_IMAGE_BY_ID = "$API_BASE_URL/images";
const API_GET_UNREAD_NOTIFICATIONS_COUNT = "$API_BASE_URL/user/notifications/unread/count";

const PREFERENCES_ACCESS_TOKEN_KEY = "preferencesAccessTokenKey";
const PREFERENCES_REFRESH_TOKEN_KEY = "preferencesRefreshTokenKey";
const PREFERENCES_EXPIRES_IN_KEY = "preferencesEpiresInKey";
const PREFERENCES_TOKEN_UPDATED_DATE_KEY = "preferencesTokenUpdatedDateKey";

class UserApiProvider implements UserProvider {
  @override
  Future<TokensResponse> authenticate({String username, String password}) async {
    final response = await http.post(API_LOGIN,
        headers: {
          HttpHeaders.authorizationHeader: Api.getBasicAuthorizationHeader(),
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        },
        body: "username=$username&password=$password&grant_type=password");

    if (response.statusCode == 400) {
      throw BadCredentialsException();
    }
    if (response.statusCode != 200) {
      print("Login failed with code ${response.statusCode}");
      throw ServerException();
    }

    print("Login succeed");

    final body = json.decode(response.body.toString());
    return TokensResponse.fromJson(body);
  }

  @override
  Future<void> deleteToken() {
    return null;
  }

  @override
  Future<bool> hasToken() async {
    final preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString(PREFERENCES_ACCESS_TOKEN_KEY);
    if (accessToken == null) return false;

    final expiresIn = preferences.getInt(PREFERENCES_EXPIRES_IN_KEY);

    final lastUpdatedDate =
        DateTime.parse(preferences.getString(PREFERENCES_TOKEN_UPDATED_DATE_KEY));

    final expiredDate = lastUpdatedDate.add(Duration(minutes: expiresIn));
    final now = DateTime.now();

    if (now.isAfter(expiredDate)) return false;

    final refreshToken = preferences.getString(PREFERENCES_REFRESH_TOKEN_KEY);

    print("Refreshing token");
    final response = await http.post(API_REFRESH_TOKEN_URL,
        headers: {
          HttpHeaders.authorizationHeader: Api.getBasicAuthorizationHeader(),
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        },
        body: "grant_type=refresh_token&refresh_token=$refreshToken");

    if (response.statusCode != 200) {
      print("unable to refresh token, error = ${response.toString()}");
      return false;
    }

    print("token refreshed");

    final body = json.decode(response.body.toString());
    final tokens = TokensResponse.fromJson(body);

    await persistTokens(tokens.accessToken, tokens.refreshToken, tokens.expiresIn);

    return true;
  }

  @override
  Future<void> updateNotificationsToken(String notificationsToken) async {
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.put(
      "$API_UPDATE_NOTIFICATION_TOKEN/$notificationsToken",
      headers: {
        HttpHeaders.authorizationHeader: tokenizedHeader,
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );

    if (response.statusCode != 200) {
      print("Error updating notifications token : ${response.statusCode}");
      print("Response ${response}");
      throw ServerException();
    }

    return true;
  }

  @override
  Future<void> persistTokens(String accessToken, String refreshToken, int expiresIn) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(PREFERENCES_ACCESS_TOKEN_KEY, accessToken);
    await preferences.setString(PREFERENCES_REFRESH_TOKEN_KEY, refreshToken);
    await preferences.setInt(PREFERENCES_EXPIRES_IN_KEY, expiresIn);
    await preferences.setString(
        PREFERENCES_TOKEN_UPDATED_DATE_KEY, DateTime.now().toIso8601String());

    return false;
  }

  @override
  Future<TokensResponse> register({@required RegistrationModel registrationModel}) async {
    final response = await http.post(API_REGISTRATION_URL,
        headers: {
          HttpHeaders.authorizationHeader: Api.getBasicAuthorizationHeader(),
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: json.encode(registrationModel.toMap()));
    if (response.statusCode == 409) {
      throw EmailAlreadyExistException();
    } else if (response.statusCode != 200) {
      throw ServerException();
    }

    final body = json.decode(response.body.toString());
    return TokensResponse.fromJson(body['authorization']);
  }

  @override
  Future<List<BusinessCard>> retrieveCards() async {
    final List<BusinessCard> cards = List();
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.get(
      API_RETRIEVE_CARDS,
      headers: {
        HttpHeaders.authorizationHeader: tokenizedHeader,
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );

    if (response.statusCode != 200) {
      print("Error getting cards : ${response.statusCode}");
      print("Response ${response}");
      throw ServerException();
    }

    final jsonBody = json.decode(response.body.toString());

    print("jsonBody of cards is = $jsonBody");

    cards.addAll((jsonBody as List).map((e) => BusinessCard.fromJson(e)).toList());
    return cards;
  }

  @override
  Future<BusinessCardDetail> retrieveCardById(int cardId) async {
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.get(
      "$API_USER_BUSINESS_META_INFO/$cardId",
      headers: {
        HttpHeaders.authorizationHeader: tokenizedHeader,
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
    final jsonBody = json.decode(response.body.toString());
    return BusinessCardDetail.fromJson(jsonBody);
  }

  @override
  Future<List<Visit>> retrieveVisits(int businessId, int fetchLimit,
      {DateTime lastFetchedDate}) async {
    final List<Visit> visits = List();
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.get(
      "$API_RETRIEVE_VISITS?businessId=$businessId&fetchLimit=$fetchLimit&lastFetchedDate=${lastFetchedDate != null ? lastFetchedDate.toIso8601String() : ""}",
      headers: {
        HttpHeaders.authorizationHeader: tokenizedHeader,
      },
    );

    if (response.statusCode != 200) {
      print("Error getting visits : ${response.statusCode}");
      print("Response $response");
      throw ServerException();
    }

    final jsonBody = json.decode(response.body.toString());

    print("jsonBody of visits is = $jsonBody");

    visits.addAll((jsonBody as List).map((e) => Visit.fromJson(e)).toList());
    return visits;
  }

  @override
  Future<List<BlackListed>> retrieveBlackListedBusinesses() async {
    final List<BlackListed> blackListed = List();
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.get(
      API_RETRIEVE_BLACKLISTED,
      headers: {
        HttpHeaders.authorizationHeader: tokenizedHeader,
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );

    if (response.statusCode != 200) {
      print("Error getting blacklisted cards : ${response.statusCode}");
      print("Response ${response}");
      throw ServerException();
    }

    final jsonBody = json.decode(response.body.toString());

    print("jsonBody of blacklisted is = $jsonBody");

    blackListed.addAll((jsonBody as List).map((e) => BlackListed.fromJson(e)).toList());
    return blackListed;
  }

  @override
  Future<IsBlackListedResponse> isBusinessBlackListed(int businessId) async {
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.get(
      "$API_RETRIEVE_IF_BUSINESS_IS_BLACKLISTED/$businessId",
      headers: {
        HttpHeaders.authorizationHeader: tokenizedHeader,
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );

    if (response.statusCode != 200) {
      print("Error getting if business is blacklisted  : ${response.statusCode}");
      print("Response ${response}");
      throw ServerException();
    }

    final jsonBody = json.decode(response.body.toString());

    print("jsonBody is = $jsonBody");

    return IsBlackListedResponse.fromJson(jsonBody);
  }

  @override
  Future<IsBlackListedResponse> toggleBlackList(int businessId) async {
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.post(
      "$API_TOGGLE_BLACKLISTED/$businessId",
      headers: {
        HttpHeaders.authorizationHeader: tokenizedHeader,
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );

    if (response.statusCode != 200) {
      print("Error toggling blacklisted business  : ${response.statusCode}");
      print("Response ${response}");
      throw ServerException();
    }

    final jsonBody = json.decode(response.body.toString());

    print("jsonBody is = $jsonBody");

    return IsBlackListedResponse.fromJson(jsonBody);
  }

  @override
  Future<BusinessImage> getImageById(int id) async {
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.get(
      "$API_GET_IMAGE_BY_ID/$id",
      headers: {
        HttpHeaders.authorizationHeader: tokenizedHeader,
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );

    if (response.statusCode != 200) {
      print("Error getting image by id  : ${response.statusCode}");
      print("Response ${response}");
      throw ServerException();
    }

    final jsonBody = json.decode(response.body.toString());

    print("jsonBody is = $jsonBody");

    return BusinessImage.fromJson(jsonBody);
  }

  Future<UnreadNotificationsResponse> retrieveUnreadNotificationsCount() async {
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.get(
      "$API_GET_UNREAD_NOTIFICATIONS_COUNT",
      headers: {
        HttpHeaders.authorizationHeader: tokenizedHeader,
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );

    if (response.statusCode != 200) {
      print("Error getting unread notifications  : ${response.statusCode}");
      print("Response ${response}");
      throw ServerException();
    }

    final jsonBody = json.decode(response.body.toString());

    print("jsonBody is = $jsonBody");

    return UnreadNotificationsResponse.fromJson(jsonBody);
  }
}
