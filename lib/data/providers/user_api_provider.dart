import 'dart:convert';
import 'dart:io';

import 'package:carl/data/api/api.dart';
import 'package:carl/data/providers/user_provider.dart';
import 'package:carl/models/business_card.dart';
import 'package:carl/models/exceptions/email_already_exist_exception.dart';
import 'package:carl/models/exceptions/server_exception.dart';
import 'package:carl/models/registration_model.dart';
import 'package:carl/models/responses/tokens_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const API_BASE_URL = "https://carl-api.herokuapp.com";
const API_REGISTRATION_URL = "$API_BASE_URL/register";
const API_REFRESH_TOKEN_URL = "$API_BASE_URL/auth/token";
const API_RETRIEVE_CARDS = "$API_BASE_URL/user/cards";

const PREFERENCES_ACCESS_TOKEN_KEY = "preferencesAccessTokenKey";
const PREFERENCES_REFRESH_TOKEN_KEY = "preferencesRefreshTokenKey";
const PREFERENCES_EXPIRES_IN_KEY = "preferencesEpiresInKey";
const PREFERENCES_TOKEN_UPDATED_DATE_KEY = "preferencesTokenUpdatedDateKey";

class UserApiProvider implements UserProvider {
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
    final cards = List();
    final tokenizedHeader = await Api.getTokenizedAuthorizationHeader();

    final response = await http.post(
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
    return cards;
  }

  @override
  Future<BusinessCard> retrieveCardById(int cardId) {
    return null;
  }
}
