import 'package:carl/models/business/visit.dart';

class ScanVisitResponse {
  final int userVisitsCount;
  final int businessVisitsMax;
  final Visit createdVisit;

  ScanVisitResponse({this.userVisitsCount, this.businessVisitsMax, this.createdVisit});

  factory ScanVisitResponse.fromJson(Map<String, dynamic> json) {
    return ScanVisitResponse(
        userVisitsCount: json['userVisitsCount'] ?? 0,
        businessVisitsMax: json['businessVisitsMax'] ?? 0,
        createdVisit: json['createdVisit'] != null ? Visit.fromJson(json['createdVisit']) : null);
  }
}
