import 'package:army120/features/auth/data/model/user.dart';

class Comments {
  int id;
  String text;
  User user;
  int post;
  String postedAt;

  Comments({this.id, this.text, this.user, this.post, this.postedAt});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    post = json['post'];
    postedAt = json['postedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['post'] = this.post;
    data['postedAt'] = this.postedAt;
    return data;
  }
}