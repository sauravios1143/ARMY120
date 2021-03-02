class GroupChallengeRequestResponse {
  String message;
  RequestData data;

  GroupChallengeRequestResponse({this.message, this.data});

  GroupChallengeRequestResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new RequestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class RequestData {
  Category category;

  RequestData({this.category});

  RequestData.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}

class Category {
  int id;
  String description;
  String identifier;
  Null image;
  bool timed;

  Category(
      {this.id, this.description, this.identifier, this.image, this.timed});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    identifier = json['identifier'];
    image = json['image'];
    timed = json['timed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['identifier'] = this.identifier;
    data['image'] = this.image;
    data['timed'] = this.timed;
    return data;
  }
}