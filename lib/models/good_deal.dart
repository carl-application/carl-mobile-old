class GoodDeal {
  final int id;
  final DateTime date;
  final String title;
  final String shortDescription;
  final String description;
  final bool seen;
  final String businessName;

  GoodDeal(this.id, this.date, this.title, this.shortDescription, this.description, this.seen,
      this.businessName);

  factory GoodDeal.fromJson(Map<String, dynamic> json) {
    print("parsing json $json");
    return GoodDeal(
      json["id"] ?? 0,
      json["date"] != null ? DateTime.parse(json["date"]) : null,
      json["title"] ?? "",
      json["shortDescription"] ?? "",
      json["description"] ?? "",
      json["seen"] ?? false,
      json["business"] != null && json["business"]["name"] != null ? json["business"]["name"] : "",
    );
  }
}
