import 'package:army120/features/prayers/data/model/prayer.dart';

class PrayersResponse {
  String message;
  List<Prayer> data;

  PrayersResponse({this.message, this.data});

  PrayersResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Prayer>();
      json['data'].forEach((v) {
        data.add(new Prayer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}





