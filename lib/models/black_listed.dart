class BlackListed {
  final int id;
  final BlackListedBusiness blackListedBusiness;

  BlackListed(this.id, this.blackListedBusiness);

  factory BlackListed.fromJson(Map<String, dynamic> json) {
    return BlackListed(json["id"] ?? 0,
        json["business"] != null ? BlackListedBusiness.fromJson(json["business"]) : null);
  }
}

class BlackListedBusiness {
  final int id;

  BlackListedBusiness(this.id);

  factory BlackListedBusiness.fromJson(Map<String, dynamic> json) {
    print("parsing json $json");
    return BlackListedBusiness(
      json["id"] ?? 0,
    );
  }
}
