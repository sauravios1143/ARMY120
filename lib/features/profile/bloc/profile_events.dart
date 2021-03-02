import 'dart:developer';
import 'dart:io';

import 'package:army120/features/profile/data/model/push_request.dart';
import 'package:army120/features/profile/data/model/update_profile_request.dart';
import 'package:flutter/foundation.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class UpdateUserDetail extends ProfileEvent {
  final UpdateProfileRequest updateProfileRequest;

  const UpdateUserDetail({@required this.updateProfileRequest});
}

class UpdatePush extends ProfileEvent {
  final PushRequest pushRequest;

  const UpdatePush({@required this.pushRequest});
}

class UpdateProfilePicture extends ProfileEvent {
  File file;

  UpdateProfilePicture({@required this.file});
}

class FetchUserDetail extends ProfileEvent {
  FetchUserDetail();
}
class FetchOtherUserDetail extends ProfileEvent {
  int userId;
  FetchOtherUserDetail({this.userId});
}
class Logout extends ProfileEvent {
  String token;
  Logout({this.token});
}
class GetPushStatus extends ProfileEvent {

}
