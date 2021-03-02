import 'package:army120/features/auth/data/model/badge.dart';
import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/ui/group_grid_view.dart';
import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/data/prayer_repository.dart';
import 'package:army120/features/prayers/ui/my_prayers.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/features/profile/ui/edit_profile.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/imageSelector.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutMe extends StatefulWidget {
  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with SingleTickerProviderStateMixin {
  //Props
  TabController _tabController;

  //getters
  get getImage {
    double height = getScreenSize(context: context).height * 0.09;
    return ClipOval(
      child: getCachedNetworkImage(
          url: LoggedInUser.getUserDetail?.profilePicture?.url ?? "",
          height: height,
          width: height,
          fit: BoxFit.cover),
    );
    return ImageSelector(
      height: getScreenSize(context: context).height * 0.09,
      width: getScreenSize(context: context).height * 0.09,
      hideEditButton: true,
    );
  }

  get getBadges {
    List<Badges> badges = LoggedInUser.getUserDetail?.badges ?? [];
    return badges.isEmpty
        ? Center(child: Text("No badge yet"))
        : GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, crossAxisSpacing: 2.0, mainAxisSpacing: 2.0),
            itemCount: badges?.length,
            itemBuilder: (context, i) {
              return Text("${badges[i].icon}");
            });
  }

  get getProfileHeader {
    Size size = getScreenSize(context: context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        children: <Widget>[
          getImage,
          getSpacer(width: size.width * 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${LoggedInUser.userDetail?.firstName ?? ""} ${LoggedInUser?.userDetail?.lastName}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: getScreenSize(context: context).height * 0.01,
                ),
                Text(LoggedInUser?.getUserDetail?.about ?? ""),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BlocProvider(
                  create: (context) =>
                      ProfileBloc(repository: ProfileRepository()),
                  child: EditProfile(),
                );
              }));
            },
            child: Image.asset(
              AssetStrings.pencil,
              height: 30,
              width: 30,
            ),
          )
        ],
      ),
    );
  }

  get getPrayerTab {
    return Container(
      height: getScreenSize(context: context).height * 0.25,
      alignment: Alignment(-1, -1),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Text(
        "My prayers",
        style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  get getBookmarkTab {
    return Container(
      height: getScreenSize(context: context).height * 0.15,
      alignment: Alignment(-1, -1),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Text(
        "My Bookmarks",
        style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppThemedAppBar(context, titleText: "About", actions: [
        Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                logout();
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.primaryColor)),
                child: Text(
                  "Logout ",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ))
      ]),
      body: Column(
        children: <Widget>[
          getProfileHeader,
          Container(
            height: getScreenSize(context: context).height * 0.1,
            color: AppColors.ultraLightBGColor,
            child: Scrollbar(
              child: getBadges,
            ),
          ),
          Divider(
            thickness: 8,
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 4,
            tabs: <Widget>[
              getTabBarItem(title: "My Pryaers"),
              getTabBarItem(title: "My Groups")
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                BlocProvider(
                    create: (BuildContext context) =>
                        PrayerBloc(prayerRepository: PrayerRepository()),
                    child: MyPrayers()), //
                BlocProvider(
                    create: (BuildContext context) =>
                        GroupBloc(groupRepository: GroupRepository()),
                    child: GroupGridView()), //todo add pages
//                BlocProvider(
//                    create: (BuildContext context) =>
//                        PrayerBloc(prayerRepository: PrayerRepository()),
//                    child: Container()),//todo add page
              ],
            ),
          )
        ],
      ),
    );
  }

//get tab bar item
  Widget getTabBarItem({title}) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ));
  }

  void logout() {
    onLogoutSuccess(context);
  }
}
