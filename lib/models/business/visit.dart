class Visit {
  final int id;
  final DateTime _date;

  get date => _date.toLocal();

  Visit(this.id, this._date);

  @override
  String toString() => 'Visit { id = $id, date = ${_date.toIso8601String()} }';

  factory Visit.fromJson(Map<String, dynamic> json) {
    print("parsing json $json");
    return Visit(json["id"] ?? 0, json["date"] != null ? DateTime.tryParse(json["date"]) : "");
  }
}
