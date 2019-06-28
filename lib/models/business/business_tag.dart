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