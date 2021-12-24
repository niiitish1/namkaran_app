class Names {
  Names({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.meaning,
    required this.gender,
  });
  late final String id;
  late final String categoryId;
  late final String name;
  late final String meaning;
  late final String gender;

  Names.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    meaning = json['meaning'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['category_id'] = categoryId;
    _data['name'] = name;
    _data['meaning'] = meaning;
    _data['gender'] = gender;
    return _data;
  }
}
