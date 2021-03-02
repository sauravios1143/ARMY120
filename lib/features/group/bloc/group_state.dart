import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/group/data/model/create_group_response.dart';
import 'package:army120/features/group/data/model/group.dart';
import 'package:army120/features/group/data/model/group_detail_response.dart';
import 'package:army120/features/group/data/model/user_listing_response.dart';
import 'package:flutter/foundation.dart';

abstract class GroupState {}

class GroupIdleState extends GroupState {}

class FetchingGroupState extends GroupState {}

class GroupFetchSuccessState extends GroupState {
  List<Group> groups;

//
  GroupFetchSuccessState({@required this.groups});
}

class GroupDetailSuccessState extends GroupState {
  List<Group> groups;

//
  GroupDetailSuccessState({@required this.groups});
}

class GroupUpdatingState extends GroupState {}

class FetchingUserState extends GroupState {}

class FetchUserSuccessState extends GroupState {
  List<SystemUser> userList;

  FetchUserSuccessState({this.userList});
}

class CreateNewGroupSuccess extends GroupState {
  CreateGroupResponse response;

  CreateNewGroupSuccess({this.response});
}

class MemberAddedSuccessState extends GroupState {
  CreateGroupResponse response;

  MemberAddedSuccessState({this.response});
}

class GroupDeletedSucces extends GroupState {
  GroupDeletedSucces();
}

class MemberRemovedSuccess extends GroupState {
  bool wasCurrentUser;
  GroupDetail groupDetail;

  MemberRemovedSuccess({this.wasCurrentUser,this.groupDetail});
}

class FetchGroupDetailSuccess extends GroupState {
  GroupDetail groupDetial;

  FetchGroupDetailSuccess({this.groupDetial});
}

class GroupErrorState extends GroupState {
  String message;

  GroupErrorState({this.message});
}
