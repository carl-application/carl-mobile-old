class UnreadNotificationsResponse {
  final int unreadNotificationsCount;

  UnreadNotificationsResponse({this.unreadNotificationsCount});

  factory UnreadNotificationsResponse.fromJson(Map<String, dynamic> json) {
    return UnreadNotificationsResponse(
        unreadNotificationsCount: json['unreadNotificationsCount'] ?? 0);
  }
}
