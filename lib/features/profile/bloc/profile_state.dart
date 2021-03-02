import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/auth/data/model/user_detail.dart';
import 'package:army120/features/profile/data/model/notificaton_model.dart';
import 'package:army120/features/profile/data/model/update_profile_response.dart';
import 'package:flutter/foundation.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class LoginProcessingState extends ProfileState {}

class FetchingDetailState extends ProfileState {}

class UpdateSuccessState extends ProfileState {
  UpdateProfileResponse updateProfileResponse;

  UpdateSuccessState({@required this.updateProfileResponse});
}
class UpdatePushSuccess extends ProfileState {

  UpdatePushSuccess();
}
class FetchPushStatus extends ProfileState {
  PushData data;
  FetchPushStatus({this.data});
}


class ProfileUpdatingState extends ProfileState {
  ProfileUpdatingState();
}

class FetchUserDetailSuccessState extends ProfileState {
  UserDetail userDetail;

  FetchUserDetailSuccessState({@required this.userDetail});
}
class LogoutSuccessState extends ProfileState {
  LogoutSuccessState();
}

class ProfileErrorState extends ProfileState {
  String message;

  ProfileErrorState({@required this.message});
}
