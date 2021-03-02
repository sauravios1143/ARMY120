
import 'package:army120/features/auth/data/model/user.dart';

class ForgotPwdResponse {
  String message;
  User data;

  ForgotPwdResponse({this.message, this.data});

  ForgotPwdResponse.fromJson(Map<String, dynamic> json) {
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

