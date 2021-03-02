import 'dart:io';
import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/bloc/group_event.dart';
import 'package:army120/features/group/bloc/group_state.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/data/model/group.dart';
import 'package:army120/features/group/data/model/group_detail_response.dart';
import 'package:army120/features/group/data/model/new_group_request.dart';
import 'package:army120/features/group/data/model/user_listing_response.dart';
import 'package:army120/features/group/ui/add_member.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/reusableWidgets/imageSelector.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditGroup extends StatefulWidget {
  Group group;

  EditGroup({this.group});

  @override
  _EditGroupState createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  int _selectedIndex = 0;
  TextEditingController nameController = new TextEditingController();
  FocusNode _searchFocus = new FocusNode();
  GroupBloc _groupBloc;
  File selectedImage;
  int maxNumber = 6;
  bool _gotData=false;
  GroupDetail _groupDetial;
  List<User> finalSelectedUser = [];

  get getTopBar {
    return Container(
      height: getScreenSize(context: context).height * 0.13,
      child: Stack(
        alignment: Alignment(0, 0),
        children: <Widget>[
          Positioned(
            top: 30,
            left: 20,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryColor,
                  size: 30,
                )),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: getAppThemedFilledButton(title: "Create", onpress: () {}),
          ),
          Positioned(
              bottom: 20,
              child: Text(
                "Create Group",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              )),
        ],
      ),
    );
  }

  get getSearchBox {
    Size _size = getScreenSize(context: context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: _size.width * 0.05,
      ),
      child: Row(
        children: <Widget>[
          ImageSelector(
            height: 70,
            width: 70,
            onSelect: (file) {
              selectedImage = file;
            },
          ),
          getSpacer(width: _size.width * 0.03),
          Expanded(child: getSearchField),
        ],
      ),
    );
  }

  Widget get getSearchField {
    return CupertinoTextField(
      controller: nameController,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      placeholder: "Group Name",
      focusNode: _searchFocus,
      placeholderStyle: TextStyle(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 2, color: AppColors.primaryColor)),
    );
  }

  Widget get getnoMemberAdded {
    return Center(
      child: Text("No members added"),
    );
  }

  Widget get getParticipantsList {
    return (finalSelectedUser?.isEmpty ?? true)
        ? getnoMemberAdded
        : ListView.builder(
            itemCount: finalSelectedUser?.length,
            itemBuilder: (context, i) {
              return getWarriorItem(warrior: finalSelectedUser[i]);
            });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getHeader(text: "Participants"),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(finalSelectedUser?.length, (i) {
            return getWarriorItem(warrior: finalSelectedUser[i]);
          }),
        )
      ],
    );

    /* GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1),
        itemBuilder: (context, i) {
          return getWarriorItem(index: i);
        });*/
  }

  Widget get getContactList {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getHeader(text: "Invite from your contact list"),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(2, (i) {
            return getContactItem(index: i);
          }),
        )
      ],
    );

/*    GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1),
        itemBuilder: (context, i) {
          return getWarriorItem(index: i);
        });*/
  }

  getWarriorItem({User warrior}) {
    return Dismissible(
      key: Key("${warrior?.id}"),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {

        bool isMineGroup = isCreatedByMe();

        return (isMineGroup && ((warrior?.id != LoggedInUser.user?.userId)));
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.delete_forever_outlined,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) {
        removeMember(warrior?.id);
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        onTap: () {},
        leading: Container(
          height: 55,
          width: 55,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.brown),
          child: ClipOval(
              child: getCachedNetworkImage(url: warrior?.firstName ?? "")),
        ),
        title: Text(warrior?.firstName ?? ""),
        /* trailing: Container(
//        height: size,
//        width: size,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.brown, width: 2),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: () {
              selectUser(warrior);
            },
            child: Icon(
              Icons.remove,
              color: Colors.brown,
              size: 24,
            ),
          ),
        ),*/
      ),
    );
  }

  getContactItem({index}) {
//    double imageSize= getScreenSize(context: context).width*0.02
    double size = 70;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      onTap: () {},
      leading: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.brown),
      ),
      title: Text("Name"),
      trailing: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//        height: size,
//        width: size,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.primaryColor)),
          child: Text("Invite")),
    );
  }

  //State methdos
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _groupBloc = BlocProvider.of<GroupBloc>(context);
    getGroupDetail();

//    if (!_gotData) {
//      _prayerBloc.add(FetchPrayers());
//    }
  }

  get getDetailView{
    return Column(
      children: <Widget>[
        Expanded(child: getParticipantsList),
        Offstage(
          offstage:(false /*!isCreatedByMe()*/),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: getButton(
                  text: "Add Members",
                  color: AppColors.appBlue,
                  onTap: getMembers)),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: isCreatedByMe()
                ? getButton(
                text: "Delete group",
                color: AppColors.primaryColor,
                onTap: deleteGroup)
                : getButton(
                text: "Leave Group",
                color: AppColors.primaryColor,
                onTap: () {
                  showAlert(
                      context: context,
                      titleText: "Warning",
                      message:
                      "Are you sure you want to leave the group?",
                      actionCallbacks: {
                        "Confirm": () {
                          removeMember(LoggedInUser.user?.userId,
                              isCurrent: true);
                        },
                        "Cancel": () {}
                      });
                })),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard(context: context, onClose: () {});
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: getAppThemedAppBar(
              context,
              titleText: "Manage",
            ),
            body:  BlocBuilder<GroupBloc, GroupState>(
                builder: (context, state) {
                  Widget _child;
                  if (state is FetchGroupDetailSuccess) {
                    //todo
                    setDetail(state?.groupDetial);

                    _child = getDetailView;
                  } else if (state is FetchingGroupState ||
                      state is GroupIdleState) {
                    _child = CustomLoader();
                  } else if (state is GroupErrorState && !_gotData) {
                    _child = getNoDataView(
                        msg: state?.message,
                        onRetry: () {
                          getGroupDetail();
                        });
                  } else {
                    _child = getDetailView;
                  }

                  return _child;
                }),
          ),
          BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              return (state is GroupUpdatingState)
                  ? CustomLoader(
                      isTransparent: false,
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    );
            },
          ),
          BlocListener<GroupBloc, GroupState>(
//                  bloc: blocA,
              child: Container(
                height: 0,
                width: 0,
              ),
              listener: (context, state) async {
                if (state is GroupErrorState) {
                  showAlert(
                      context: context,
                      titleText: "Error",
                      message: state?.message ?? "",
                      actionCallbacks: {"Ok": () {}});
                }
                if (state is CreateNewGroupSuccess) {
                  showAlert(
                      context: context,
                      titleText: "Success",
                      message: "Group created successfully",
                      actionCallbacks: {
                        "Ok": () {
                          Navigator.pop(context, 1);
                        }
                      });
                }
                if (state is MemberAddedSuccessState) {
                  showAlert(
                      context: context,
                      titleText: "Success",
                      message: "Member updated successfully",
                      actionCallbacks: {
                        "Ok": () {
                          Navigator.pop(context);
                        }
                      });
                }
                if (state is MemberRemovedSuccess) {
                  if (state?.wasCurrentUser ?? false) {
                    showAlert(
                        context: context,
                        titleText: "Success",
                        message: "Group left  successfully",
                        actionCallbacks: {
                          "Ok": () {
                            Navigator.pop(context, 1);
                          }
                        });
                  } else {
                    setDetail(state?.groupDetail);
                  }
                }
                if (state is GroupDeletedSucces) {
                  showAlert(
                      context: context,
                      titleText: "Success",
                      message: "Group Deleted successfully",
                      actionCallbacks: {
                        "Ok": () {
                          Navigator.pop(context, 1);
                        }
                      });
                }
                if (state is FetchGroupDetailSuccess) {
                  setDetail(state?.groupDetial);
                }
              })
        ],
      ),
    );
  }

  getGroupDetail() {
    _groupBloc.add(FetchGroupDetail(groupId: widget?.group?.id));
  }

  Widget getHeader({text}) {
    return Container(
        alignment: Alignment(-1, 0),
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            color: AppColors.ultraLightBGColor,
            border: Border(
                bottom: BorderSide(color: AppColors.primaryColor, width: 2))),
        child: Text(
          text ?? "",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ));
  }

  selectUser(warrior) {
    finalSelectedUser.remove(warrior);
    setState(() {});
  }

//get meber
  getMembers() async {
    var x = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (context) => GroupBloc(groupRepository: GroupRepository()),
          child: AddMembers());
    }));

    if (x is List && x?.isNotEmpty) {
      addMembers(x);
    }
  }

  deleteGroup() {
    showAlert(
        context: context,
        titleText: "Warning",
        message: "Are you sure you want to delete group",
        actionCallbacks: {
          "Confirm": () {
            _groupBloc.add(DeleteGroup(id: widget?.group?.id));
          },
          "Cancel": () {}
        });
  }

  //add member api
  addMembers(List<SystemUser> userList) {
    _groupBloc.add(EdiitOrAddMember(
        request: NewGroupRequest(
            groupId: widget?.group?.id,
            name: nameController.text,
            imageFile: selectedImage,
            members: List.generate(
                userList?.length, (index) => userList[index]?.objectID))));
  }

  void setDetail(GroupDetail detail) {
    _gotData=true;
    _groupDetial = detail;
    finalSelectedUser = detail?.group?.members;
  }

  void removeMember(int id, {isCurrent: false}) {
    _groupBloc.add(
        RemoveMember(id: id, isCurrent: isCurrent, groupId: widget?.group?.id));
  }

  bool isCreatedByMe() {
    return (LoggedInUser?.user.userId == _groupDetial?.group?.creator);
  }


}
