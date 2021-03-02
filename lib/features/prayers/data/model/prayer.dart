import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/prayers/data/model/comment.dart';

class Prayer {
  int id;
  String text;
  User user;
  String postedAt;
  int prayAlongCount;
  List<User> prayAlongs;
  bool iPrayedAlong;
  int commentCount;
  List<Comments> comments;

  Prayer(
      {this.id,
        this.text,
        this.user,
        this.postedAt,
        this.prayAlongCount,
        this.prayAlongs,
        this.iPrayedAlong,
        this.commentCount,
        this.comments});

  Prayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    postedAt = json['postedAt'];
    prayAlongCount = json['prayAlongCount'];
    if (json['prayAlongs'] != null) {
      prayAlongs = new List<User>();
      json['prayAlongs'].forEach((v) {
        prayAlongs.add(new User.fromJson(v));
      });
    }
    iPrayedAlong = json['iPrayedAlong'];
    commentCount = json['commentCount'];
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['postedAt'] = this.postedAt;
    data['prayAlongCount'] = this.prayAlongCount;
    if (this.prayAlongs != null) {
      data['prayAlongs'] = this.prayAlongs.map((v) => v.toJson()).toList();
    }
    data['iPrayedAlong'] = this.iPrayedAlong;
    data['commentCount'] = this.commentCount;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}