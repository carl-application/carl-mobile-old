class TokensResponse {
  final String accessToken;
  final int expiresIn;
  final String refreshToken;

  TokensResponse({this.accessToken, this.expiresIn, this.refreshToken});

  factory TokensResponse.fromJson(Map<String, dynamic> json) {
    return TokensResponse(
      accessToken: json['access_token'] as String,
      expiresIn: json['expires_in'] as int,
      refreshToken: json['refresh_token'] as String,
    );
  }
}
