import 'package:army120/features/auth/data/model/user_detail.dart';

class UserDetailResponse {
  String message;
  UserDetail data;

  UserDetailResponse({this.message, this.data});

  UserDetailResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new UserDetail.fromJson(json['data']) : null;
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

