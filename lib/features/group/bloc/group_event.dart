import 'package:army120/features/group/data/model/new_group_request.dart';
import 'package:flutter/foundation.dart';

//Group Events
abstract class GroupEvent {
  const GroupEvent();
}

//Fetch Group list
class FetchGroup extends GroupEvent {
//  const FetchGroup();
} //Fetch Group list

class FetchUserEvent extends GroupEvent {
  String searchBy;

  FetchUserEvent({this.searchBy});
}

//fetch Group detail
class FetchGroupDetail extends GroupEvent {
  int groupId;

  FetchGroupDetail({@required this.groupId});
}

//create new post
class CreateNewGroup extends GroupEvent {
  NewGroupRequest request;

  CreateNewGroup({@required this.request});
}

//Add member
class EdiitOrAddMember extends GroupEvent {
  NewGroupRequest request;

  EdiitOrAddMember({@required this.request});
}

class DeleteGroup extends GroupEvent {
  int id;

  DeleteGroup({@required this.id});
}

class RemoveMember extends GroupEvent {
  int id;
  bool isCurrent;
  int groupId;

  RemoveMember({@required this.id,this.isCurrent,this.groupId});
}
//create new post
