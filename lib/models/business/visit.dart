class Visit {
  final int id;
  final DateTime date;

  Visit(this.id, this.date);

  @override
  String toString() => 'Visit { id = $id, date = ${date.toIso8601String()} }';

  factory Visit.fromJson(Map<String, dynamic> json) {
    print("parsing json $json");
    return Visit(json["id"] ?? 0, json["date"] != null ? DateTime.tryParse(json["date"]) : "");
  }
}
