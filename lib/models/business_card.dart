import 'dart:core';

import 'business_image.dart';
import 'business_tag.dart';

class BusinessCard {
  BusinessCard(this.id, this.businessName, this.businessAddress, this.image, this.logo, this.tags,
      this.total, this.description);

  final int id;
  final String businessName;
  final String businessAddress;
  final BusinessImage image;
  final BusinessImage logo;
  final List<Tag> tags;
  final int total;
  final String description;

  factory BusinessCard.fromJson(Map<String, dynamic> json) {
    print("Parsing json $json");
    return BusinessCard(
      json["id"] ?? 0,
      json["name"] ?? "Wrong name",
      json["address"] ?? "Wrong address",
      json["image"] != null ? BusinessImage.fromJson(json["image"]) : BusinessImage(0, "Wrong image"),
      json["logo"] != null ? BusinessImage.fromJson(json["logo"]) : BusinessImage(1, "Wrong url"),
      json["tags"] != null ? (json["tags"] as List).map((e) => Tag.fromJson(e)).toList() : [],
      json["fidelityMax"] ?? 10,
      json["description"] ?? "No description",
    );
  }
}
