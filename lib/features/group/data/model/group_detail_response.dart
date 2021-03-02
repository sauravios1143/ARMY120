import 'package:army120/features/group/data/model/group.dart';

class GroupDetailResponse {
  String message;
  GroupDetail data;

  GroupDetailResponse({this.message, this.data});

  GroupDetailResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new GroupDetail.fromJson(json['data']) : null;
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

class GroupDetail {
  Group group;

  GroupDetail({this.group});

  GroupDetail.fromJson(Map<String, dynamic> json) {
    group = json['group'] != null ? new Group.fromJson(json['group']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.group != null) {
      data['group'] = this.group.toJson();
    }
    return data;
  }
}

