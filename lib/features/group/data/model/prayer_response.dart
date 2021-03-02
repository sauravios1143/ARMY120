import 'package:army120/features/group/data/model/group.dart';

class GroupListResponse {
  String message;
  Data data;

  GroupListResponse({this.message, this.data});

  GroupListResponse.fromJson(Map<String, dynamic> json) {
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
  List<Group> groups;

  Data({this.groups});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['groups'] != null) {
      groups = new List<Group>();
      json['groups'].forEach((v) {
        groups.add(new Group.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.groups != null) {
      data['groups'] = this.groups.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
