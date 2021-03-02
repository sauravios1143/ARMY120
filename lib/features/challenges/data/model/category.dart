class Categories {
  int id;
  String description;
  String identifier;
  Null image;

  Categories({this.id, this.description, this.identifier, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    identifier = json['identifier'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['identifier'] = this.identifier;
    data['image'] = this.image;
    return data;
  }
}