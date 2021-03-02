import 'package:army120/features/prayers/data/model/prayer.dart';

class PrayerByCommentResponse {
  String message;
  Data data;

  PrayerByCommentResponse({this.message, this.data});

  PrayerByCommentResponse.fromJson(Map<String, dynamic> json) {
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
  Prayer post;

  Data({this.post});

  Data.fromJson(Map<String, dynamic> json) {
    post = json['post'] != null ? new Prayer.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}
