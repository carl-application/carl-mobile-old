class IsBlackListedResponse {
  final bool isBlackListed;

  IsBlackListedResponse({this.isBlackListed});

  factory IsBlackListedResponse.fromJson(Map<String, dynamic> json) {
    return IsBlackListedResponse(
      isBlackListed: json['isBlackListed'] ?? false,
    );
  }
}
