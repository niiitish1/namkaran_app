class CasteCategory {
  String? id;
  String? catName;

  CasteCategory({this.id, this.catName});

  CasteCategory.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.catName = json["cat_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["cat_name"] = this.catName;
    return data;
  }
}
