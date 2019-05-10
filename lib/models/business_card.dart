import 'dart:core';

class BusinessCard {
  BusinessCard(this.id, this.businessName, this.businessAddress, this.imageUrl, this.logo,
      this.tags, this.progression, this.total, this.description);

  final int id;
  final String businessName;
  final String businessAddress;
  final String imageUrl;
  final String logo;
  final List<Tag> tags;
  final int progression;
  final int total;
  final String description;

  factory BusinessCard.fromJson(Map<String, dynamic> json) {
    return BusinessCard(
      json["id"] ?? 0,
      json["businessName"] ?? "Wrong name",
      json["businessAddress"] ?? "Wrong address",
      json["imageUrl"] ?? "Wrong url",
      json["logo"] ?? "Wrong logo",
      json["tags"].map((e) => Tag.fromJson(e)).toList(),
      json["progression"] ?? 2,
      json["total"] ?? 10,
      json["description"] ?? "Wrong description",
    );
  }
}

class Tag {
  final int id;
  final String name;

  Tag(this.id, this.name);

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      json["id"] ?? 0,
      json["name"] ?? "Wrong tag",
    );
  }
}
