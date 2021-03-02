import 'package:army120/features/auth/data/model/badge.dart';
import 'package:army120/features/auth/data/model/user_detail.dart';
import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/data/prayer_repository.dart';
import 'package:army120/features/prayers/ui/my_prayers.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/bloc/profile_events.dart';
import 'package:army120/features/profile/bloc/profile_state.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/features/profile/ui/edit_profile.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum profileAction { edit, logout }

class UserDetailScreen extends StatefulWidget {
  final int userId;

  UserDetailScreen({this.userId});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  int _selectedIndex = 0;
  bool _gotData = false;
  ProfileBloc _ProfileBloc;
  UserDetail userDetail;

  //getters
  get getImage {
    double height = getScreenSize(context: context).width * 0.2;
    return ClipOval(
      child: getCachedNetworkImage(
          url: userDetail?.profilePicture?.url ?? "",
          height: height,
          width: height,
          fit: BoxFit.cover),
    );
  }

  get getProfileHeader {
    Size size = getScreenSize(context: context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Row(
        children: [
          getImage,
          getSpacer(width: size.width*0.08),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${userDetail?.firstName ?? ""} ${userDetail?.lastName}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: getScreenSize(context: context).height * 0.01,
                ),
                Text(userDetail?.about ?? ""),
              ],
            ),
          ),
        ],
      ),
    );
  }

  get getBadges {
    List<Badges> badges = userDetail?.badges ?? [];
    return Container(
      width: double.maxFinite,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Badges:",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
          ),
          getSpacer(height: 8),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.ultraLightBGColor,
              borderRadius: BorderRadius.circular(7)
            ),
            child:  badges.isEmpty
                ? Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.0),
                child: Text("No badge earned yet"))
                : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                  badges?.length,
                      (index) => Tooltip(
                    preferBelow: false,

                    message: badges[index]?.reason??"",
                    child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${badges[index].icon}"),
                        )),
                  )),
            ),
          ),

        ],
      ),
    );
  }

  get getButton {
    return Material(
      color: AppColors.primaryColor,
      elevation: 0.4,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlocProvider(
                create: (BuildContext context) =>
                    PrayerBloc(prayerRepository: PrayerRepository()),
                child: MyPrayers(
                  userId: userDetail?.id,
                ));
          }));
        },
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "My prayers",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  get getUserDetailView {
    double height = getScreenSize(context: context).height;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.05, horizontal: height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          getProfileHeader,
          getSpacer(height: height * 0.02),
          getBadges,
          getSpacer(height: height * 0.1),
          getButton,
        ],
      ),
    );
  }

  Widget get getPage{
    return Column(
      children: <Widget>[
        Expanded(
          child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                Widget _child;
                if (state is FetchUserDetailSuccessState) {
                  //todo
                  setData(state);

                  _child = getUserDetailView;
                } else if (state is FetchingDetailState ||
                    state is ProfileInitialState) {
                  _child = CustomLoader();
                } else if (state is ProfileErrorState && !_gotData) {
                  _child = getNoDataView(
                      msg: state?.message,
                      onRetry: () {
                        fetchUserDetail();
                      });
                } else {
                  _child = getUserDetailView;
                }

                return _child;
              }),
        )
      ],
    );
}

  //State methods

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gotData) {
      _ProfileBloc = BlocProvider.of<ProfileBloc>(context);
      fetchUserDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: getAppThemedAppBar(context, titleText: "User Detail", actions: [
        Offstage(
          offstage: LoggedInUser.user?.userId != widget?.userId,
            child: getProfilePopUp()),
       /* IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BlocProvider(
                  create: (context) =>
                      ProfileBloc(repository: ProfileRepository()),
                  child: EditProfile(),
                );
              }));
            }),*/
      ]),
      body: Stack(
        children: [
          getPage,
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Offstage(
                offstage: !(state is ProfileUpdatingState),
                child: CustomLoader(isTransparent: false),
              );
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
              child: Container(
                height: 0,
                width: 0,
              ),
              listener: (context, state) async {
                if (state is ProfileErrorState) {
                  showAlert(
                      context: context,
                      titleText: "Error",
                      message: state?.message ?? "",
                      actionCallbacks: {"Ok": () {}});
                }
                if (state is UpdateSuccessState) {
                  showAlert(
                      context: context,
                      titleText: "Success",
                      message: "Profile updated",
                      actionCallbacks: {"Ok": () {}});
                }  if (state is LogoutSuccessState) {
                    logoutSuccessActions();
                }
              })
        ],
      )
    );

  }
  Widget getProfilePopUp() {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text("Edit"),
            value: profileAction.edit,
          ),
          PopupMenuItem(
            child: Text("Logout"),
            value: profileAction.logout,
          )
        ];
      },
      onSelected: (profileAction value) {
        switch (value) {
          case profileAction.edit:
            editProfile();
            break;
          case profileAction.logout:
            logout();
            break;
        }
      },
    );
  }

  //other methods

  editProfile() async{
    //
   var value =  await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider(
        create: (context) =>
            ProfileBloc(repository: ProfileRepository()),
        child: EditProfile(),
      );
    }));
   if(value==1){
     fetchUserDetail();
   }
  }


  //fetch challenges category
  fetchUserDetail() {
    _ProfileBloc.add(FetchOtherUserDetail(userId: widget?.userId));
  }

  //set category data
  setData(FetchUserDetailSuccessState state) {
    _gotData = true;
    userDetail = state?.userDetail;
  }

  logout()async{
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String token = await _firebaseMessaging.getToken() ?? "";
    _ProfileBloc.add(Logout(
      token: token
    ));
    // onLogoutSuccess(context);
  }

  void logoutSuccessActions() {
    onLogoutSuccess(context);
  }


}
