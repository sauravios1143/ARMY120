import 'package:army120/features/auth/data/model/user.dart';

class PatronListResponse {
  String message;
  Data data;

  PatronListResponse({this.message, this.data});

  PatronListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<User> patrons;

  Data({this.patrons});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['patrons'] != null) {
      patrons = new List<User>();
      json['patrons'].forEach((v) {
        patrons.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patrons != null) {
      data['patrons'] = this.patrons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
