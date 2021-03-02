
import 'package:army120/features/auth/data/model/profile_ficture.dart';
import 'package:army120/features/auth/data/model/user.dart';

class Group {
  int id;
  String name;
  String kind;
  String createdAt;
  int creator;
  ProfilePicture icon;
  List<User> members;

  Group(
      {this.id,
        this.name,
        this.kind,
        this.createdAt,
        this.creator,
        this.icon,
        this.members});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    kind = json['kind'];
    createdAt = json['createdAt'];
    creator = json['creator'];
    icon = json['icon'] != null ? new ProfilePicture.fromJson(json['icon']) : null;
    if (json['members'] != null) {
      members = new List<User>();
      json['members'].forEach((v) {
        members.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['kind'] = this.kind;
    data['createdAt'] = this.createdAt;
    data['creator'] = this.creator;
    if (this.icon != null) {
      data['icon'] = this.icon.toJson();
    }
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}