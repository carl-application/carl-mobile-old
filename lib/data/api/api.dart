import 'dart:convert';

import 'package:carl/data/providers/user_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static String getBasicAuthorizationHeader() {
    final clientID = "com.thomasecalle.carl";

    final clientCredentials = Base64Encoder().convert("$clientID:carlapplicationsecret".codeUnits);

    return "Basic $clientCredentials";
  }

  static Future<String> getTokenizedAuthorizationHeader() async {
    final preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString(PREFERENCES_ACCESS_TOKEN_KEY);

    return "Bearer $accessToken";
  }
}
