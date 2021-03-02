import 'dart:io';

import 'package:army120/features/auth/data/model/profile_ficture.dart';

class NewGroupRequest {
  int groupId;
  String name;
  String kind;
  ProfilePicture icon;
  List<String> members;
  File imageFile;

  NewGroupRequest({this.name, this.icon, this.members,this.imageFile,this.kind,this.groupId});

  NewGroupRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    name = json['kind'];
    icon = json['icon'] != null
        ? new ProfilePicture.fromJson(json['icon'])
        : null;
    members = json['members'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['kind'] = this.kind;
    if (this.icon != null) {
      data['icon'] = this.icon.toJson();
    }
    data['members'] = this.members;
    return data;
  }
}