import 'dart:core';

import 'package:carl/models/business/business_card.dart';

class BusinessCardDetail {
  BusinessCardDetail(this.userVisitsCount, this.business);

  final int userVisitsCount;
  final BusinessCard business;

  factory BusinessCardDetail.fromJson(Map<String, dynamic> json) {
    return BusinessCardDetail(
        json["userVisitsCount"] ?? 0,
        BusinessCard.fromJson(json["business"]));
  }
}
