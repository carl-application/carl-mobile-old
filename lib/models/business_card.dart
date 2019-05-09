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
}

class Tag {
  final int id;
  final String name;

  Tag(this.id, this.name);
}
