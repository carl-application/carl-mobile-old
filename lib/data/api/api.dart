import 'dart:convert';

class Api {
  static String getBasicAuthorizationHeader() {
    final clientID = "com.thomasecalle.carl";

    final clientCredentials = Base64Encoder().convert("$clientID:carlapplicationsecret".codeUnits);

    return "Basic $clientCredentials";
  }
}
