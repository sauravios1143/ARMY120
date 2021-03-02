import 'package:army120/features/prayers/data/model/prayer.dart';

class PrayerDetailResponse {
  String message;
  Prayer data;

  PrayerDetailResponse({this.message, this.data});

  PrayerDetailResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Prayer.fromJson(json['data']) : null;
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

