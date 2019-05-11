class BusinessImage {
  final int id;
  final String url;

  BusinessImage(this.id, this.url);

  factory BusinessImage.fromJson(Map<String, dynamic> json) {
    return BusinessImage(
      json["id"] ?? 0,
      json["url"] ?? "Wrong url",
    );
  }
}
