import 'dart:io';
import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/bloc/group_event.dart';
import 'package:army120/features/group/bloc/group_state.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/data/model/group.dart';
import 'package:army120/features/group/data/model/new_group_request.dart';
import 'package:army120/features/group/data/model/user_listing_response.dart';
import 'package:army120/features/group/ui/add_member.dart';
import 'package:army120/utils/Constants/enumConst.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_appbar.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/reusableWidgets/imageSelector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupPreview extends StatefulWidget {
  final List<SystemUser> selectedUser;
  final groupType type;
  Group group;

  GroupPreview({@required this.selectedUser, this.type, this.group});

  @override
  _GroupPreviewState createState() => _GroupPreviewState();
}

class _GroupPreviewState extends State<GroupPreview> {
  int _selectedIndex = 0;
  TextEditingController nameController = new TextEditingController();
  FocusNode _searchFocus = new FocusNode();
  GroupBloc _groupBloc;
  File selectedImage;
  int maxNumber = 6;

  List<SystemUser> finalSelectedUser;

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
    return (finalSelectedUser?.isEmpty)
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

  getWarriorItem({SystemUser warrior}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      onTap: () {},
      leading: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.brown),
        child: ClipOval(child: getCachedNetworkImage(url: warrior?.name ?? "")),
      ),
      title: Text(warrior?.name ?? ""),
      trailing: Container(
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
    finalSelectedUser = widget?.selectedUser;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _groupBloc = BlocProvider.of<GroupBloc>(context);

//    if (!_gotData) {
//      _prayerBloc.add(FetchPrayers());
//    }
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
            appBar: getAppThemedAppBar(context, titleText: "Create", actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: (widget?.group == null)
                      ? getAppThemedFilledButton(
                          title: "Create", onpress: createGroup)
                      : getAppThemedFilledButton(
                          title: "Update", onpress: editGroup),
                ),
              )
            ]),
            body: Column(
              children: <Widget>[
                // CustomAppBar(
                //     title: "Create Group",
                //     trailing: getAppThemedFilledButton(
                //         title: "Create", onpress: createGroup)),

//                getTopBar,
                Divider(
                  height: 8,
                  color: Colors.grey[300],
                  thickness: 10,
                ),
                getSearchBox,
                Expanded(child: getParticipantsList),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: getButton(
                        text: "Add Members",
                        color: AppColors.appBlue,
                        onTap: getMembers)),
              ],
            ),
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
                      message: "Group created succesfully",
                      actionCallbacks: {
                        "Ok": () {
                          Navigator.pop(context, 1);
                        }
                      });
                }
              })
        ],
      ),
    );
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

  createGroup() {
    if (nameController?.text?.trim()?.isNotEmpty) {
      if (isBeyondMembersLimit()) {
        showAlert(
            context: context,
            titleText: "Warning",
            message: "You can only select maximum ${maxNumber} members",
            actionCallbacks: {"ok": () {}});

        return;
      }

      _groupBloc.add(CreateNewGroup(
          request: NewGroupRequest(
              kind: getKind(),
              name: nameController.text,
              imageFile: selectedImage,
              members: List.generate(finalSelectedUser?.length,
                  (index) => finalSelectedUser[index]?.objectID))));
    } else {
      showAlert(
          context: context,
          titleText: "Error",
          message: "Pleser enter group name",
          actionCallbacks: {"Ok": () {}});
    }
  }

  editGroup() {
    if (nameController?.text?.trim()?.isNotEmpty) {
      if (isBeyondMembersLimit()) {
        showAlert(
            context: context,
            titleText: "Warning",
            message: "You can only select maximum ${maxNumber} members",
            actionCallbacks: {"ok": () {}});

        return;
      }

      _groupBloc.add(EdiitOrAddMember(
          request: NewGroupRequest(
              name: nameController.text,
              imageFile: selectedImage,
              members: List.generate(finalSelectedUser?.length,
                  (index) => finalSelectedUser[index]?.objectID))));
    } else {
      showAlert(
          context: context,
          titleText: "Error",
          message: "Pleser enter group name",
          actionCallbacks: {"Ok": () {}});
    }
  }

  getMembers() async {
    var x = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (context) => GroupBloc(groupRepository: GroupRepository()),
          child: AddMembers());
    }));

    if (x is List) {
      finalSelectedUser = x;
      setState(() {});
    }
  }

  bool isBeyondMembersLimit() {
    if (widget?.type == groupType.free &&
        finalSelectedUser?.length >= maxNumber) {
      return true;
    } else {
      return false;
    }
  }

  getKind() {
    String value = '';

    switch (widget?.type) {
      case groupType.free:
        value = "free";
        break;
      case groupType.community:
        value = "paid";
        break;
    }

    return value;
  }
}
