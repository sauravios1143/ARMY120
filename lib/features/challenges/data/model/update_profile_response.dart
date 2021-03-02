
import 'package:army120/features/auth/data/model/user.dart';

class UpdatePrfileResponse {
  String message;
  User data;

  UpdatePrfileResponse({this.message, this.data});

  UpdatePrfileResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new User.fromJson(json['data']) : null;
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

