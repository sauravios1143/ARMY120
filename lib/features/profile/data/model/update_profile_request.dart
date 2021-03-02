import 'dart:io';

import 'package:army120/features/auth/data/model/profile_ficture.dart';
import 'package:army120/utils/Constants/next_step.dart';
import 'package:army120/utils/Constants/profileConstant.dart';

class UpdateProfileRequest {
  String userName;

//  String password;

  String gender;
  int dob;
  String bio;
  String email;
  String phone;
  String name;
  File file;
  ProfilePicture profilePicture;
  String currentStep;
  String token;

  UpdateProfileRequest({
    this.userName,
//        this.password
    this.gender,
    this.dob,
    this.currentStep,
    this.file,
    this.profilePicture,this.
  phone,this.email,this.name,this. bio,this.token
  });

  UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
//    password = json['password'];
    name = json['name'];
    dob = json['dateOfBirth'];
    email = json['email'];
    phone = json['phone'];
    profilePicture = json['profilePicture'] != null
        ? new ProfilePicture.fromJson(json['profilePicture'])
        : null;
    bio = json['about'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    // data['dateOfBirth'] = this.dob;
    data['about'] = this.bio;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['name'] = this.name;
    // data['push'] = this.token;
    if (this.profilePicture != null) {
      data['profilePicture'] = this.profilePicture.toJson();
    }
    return data;
  }

  Map<String, dynamic> toJsonByStep(String type) {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    switch (type) {
      case NextStep.gender:
        data['gender'] = this.gender;
        break;
      case NextStep.dob:
        data['dateOfBirth'] = this.dob;
        break;
      case NextStep.picture:
        if (this.profilePicture != null) {
          data['profilePicture'] = this.profilePicture.toJson();
        }
        break;
      case NextStep.about:
        data['about'] = this.bio;
        break;
      case NextStep.phone:
        data['phone'] = this.phone;
        break;
        case NextStep.push:
        data['[push]'] = this.token;
        break;
    }

//    data['user_name'] = this.userName;
//    data['email'] = this.email;
//    data['name'] = this.name;

    return data;
  }
}
