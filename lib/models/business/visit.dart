class Visit {
  final int id;
  final DateTime _date;
  final int businessId;

  get localDate => _date.toLocal();

  get date => _date;

  Visit(this.id, this._date, {this.businessId});

  @override
  String toString() => 'Visit { id = $id, date = ${_date.toIso8601String()} }';

  factory Visit.fromJson(Map<String, dynamic> json) {
    print("parsing json $json");
    return Visit(json["id"] ?? 0, json["date"] != null ? DateTime.tryParse(json["date"]) : "",
        businessId: json["business"] != null ? json["business"]["id"] : 0);
  }
}
