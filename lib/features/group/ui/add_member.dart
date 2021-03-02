import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/bloc/group_event.dart';
import 'package:army120/features/group/bloc/group_state.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/data/model/user_listing_response.dart';
import 'package:army120/features/group/ui/group_preview.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_appbar.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';

class AddMembers extends StatefulWidget {
  @override
  _AddMembersState createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  int _selectedIndex = 0;
  TextEditingController _searchController = new TextEditingController();
  FocusNode _searchFocus = new FocusNode();

  bool gotData;

  List<SystemUser> warriorList = [];
  bool _gotData = false;
  GroupBloc _groupBloc;
  List<SystemUser> selectedUser = [];

  get getTopBar {
    return CustomAppBar(
      title: "Create Group",
      trailing: getAppThemedFilledButton(
          title: "Create",
          onpress: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlocProvider(
                  create: (context) =>
                      GroupBloc(groupRepository: GroupRepository()),
                  child: GroupPreview(
                    selectedUser: selectedUser,
                  ));
            }));
          }),
    );
  }

  get getSearchBox {
    Size _size = getScreenSize(context: context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _size.width * 0.1,
      ),
      child: Column(
        children: <Widget>[
          getSpacer(height: _size.height * 0.03),
          getSearchField,
          getSpacer(height: 8),
          /*Align(
            alignment: Alignment(1, 0),
            child: Text(
              "Participants: 0/6",
              style: TextStyle(fontSize: 16),
            ),
          ),*/
        ],
      ),
    );
  }

  get getSearchField {
    return appThemedTextFieldTwo(
        label: "Search",
        controller: _searchController,
        context: context,
        focusNode: _searchFocus,
        onChange: onTextChange,
        prefix: Icon(Icons.search));
  }

  Widget get getWarriorsList {
    return (warriorList?.isEmpty)
        ? inviteUserView
        : ListView.builder(
        itemCount: warriorList?.length,
        itemBuilder: (context, i) {

            return getWarriorItem(warrior: warriorList[i]);
          });
/*      Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getHeader(text: "120 Warriors"),
        (warriorList?.isEmpty)
            ? getNoUserView()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(warriorList?.length, (i) {
                  return getWarriorItem(warrior: warriorList[i]);
                }),
              )
      ],
    );*/

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
      onTap: () {
        selectUser(warrior);
      },
      leading: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.brown),
        child: ClipOval(child: Container()
//            getCachedNetworkImage(
//                url: warrior?.profilePicture?.thumbnailUrl ?? "")
            ),
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
            (selectedUser?.contains(warrior)) ? Icons?.check : Icons.add,
            color: Colors.brown,
            size: 24,
          ),
        ),
      ),
    );
  }



  //State methods

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gotData) {
      _groupBloc = BlocProvider.of<GroupBloc>(context);
      fetchUsers();
      getPhoneContact();
    }
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
            appBar: getAppThemedAppBar(context, titleText: "Add Members"),
            body: Column(
              children: <Widget>[
                // getTopBar,

                getSearchBox,
                Expanded(
                  child: getWarriorView,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: getButton(
                      text: "Add Members",
                      color: AppColors.appBlue,
                      onTap: () {
                        // selectedUser=[ SystemUser(objectID:"2" ),];
                        Navigator.pop(context, selectedUser);
                      }),
                ),
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
//              if (state is PrayerCommentSuccess) {
//                _commentController.clear();
//                _prayerBloc.add(FetchPrayerDetail(prayerId: widget?.prayerId));
//              }
//              if (state is PrayAlongSuccessState) {
//                onPrayAlongSuccess(state:state);
//              }
              })
        ],
      ),
    );
  }

  Widget get inviteUserView {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("No User Found"),
          getSpacer(
            height: 8
          ),
          getAppThemedFilledButton(title: "Invite", onpress:invite)
        ],
      ),
    );
  }

  Widget get getPage {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: <Widget>[
            getWarriorView,
            // getSpacer(height: 60),
            // getContactView
          ],
        ));
  }

  Widget get getWarriorView {
    return BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
      return Builder(
        builder: (context) {
          Widget _child;
          if (state is FetchUserSuccessState) {
            setData(state: state);
            _child = getWarriorsList;
          } else if ((gotData == false) &&
              (state is FetchingUserState || state is GroupIdleState)) {
            _child = CustomLoader();
          } else if (state is GroupErrorState && !_gotData) {
            _child = getNoDataView(
                msg: state?.message,
                onRetry: () {
                  fetchUsers();
                });
          } else {
            _child = getWarriorsList;
          }

          return _child;
        },
      );
    });
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

  fetchUsers() {
    String query = _searchController?.text ?? "";
    _groupBloc.add(FetchUserEvent(searchBy: (query?.isEmpty) ? " " : query));
  }

  setData({FetchUserSuccessState state}) {
    gotData = true;
    warriorList = state?.userList;
//    getPhoneContact();
  }

  getPhoneContact() async {
    /*Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: true);
    localContact = contacts.toList();
    print("localContact${localContact?.length}");
    setState(() {});*/
  }

  selectUser(SystemUser user) {
    if (selectedUser?.contains(user)) {
      selectedUser.remove(user);
    } else {
      selectedUser.add(user);
    }
    setState(() {});
  }

  onTextChange(str) {
    fetchUsers();
  }

  //share prayer
  invite() async {
    await FlutterShare.share(
      title: "Join 120 Army",
      text: AppMessages.inviteMessage,
//        linkUrl: product?.permalink??"",
      //chooserTitle: 'Example Chooser Title'
    );
  }
}

