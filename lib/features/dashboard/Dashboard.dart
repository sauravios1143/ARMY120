import 'dart:convert';
import 'package:army120/features/challenges/bloc/challenge_bloc.dart';
import 'package:army120/features/challenges/ui/challenges.dart';
import 'package:army120/features/challenges/data/challenge_repository.dart';
import 'package:army120/features/events/ui/event_home.dart';
import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/data/revenukat_services.dart';
import 'package:army120/features/notifications/data/model/notification.dart';
import 'package:army120/features/group/ui/group_listing_screen.dart';
import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/data/prayer_repository.dart';
import 'package:army120/features/prayers/ui/prayer_detail.dart';
import 'package:army120/features/prayers/ui/prayers_listing.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/features/profile/ui/user_detail_screen.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/Constants/notifcation_type.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/reusableWidgets/customBottomBar.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  //props

  TabController tabController;
  int _numberOfTabs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Widget> tabChildren = [];
  List<NavigationBarItem> bottomBarChildren = [];

  //getters
  get getBottomNavigation {
    return CustomBottomBar(controller: tabController, items: bottomBarChildren);
  }

  //
  get getTabBarView {
    return TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: tabChildren);
  }

  moveToScreen(int index) {
    tabController.animateTo(index, duration: Duration(milliseconds: 100));
    setState(() {});
  }

  //State management

  @override
  void initState() {
    _numberOfTabs = isLoggedIn() ? 5 : 3;
    tabController = new TabController(length: _numberOfTabs, vsync: this);
    setTabs();

    super.initState();
    configurePushNotification();
    setUpRevenueCat();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getTabBarView,
      bottomNavigationBar: getBottomNavigation,
    );
  }

  //Widgets

  ///get Draer item
  getDraerItem({icon, title, isSelected: false, color}) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: isSelected ? color ?? Colors.black : Colors.black,
      ),
      title: Text(
        title ?? "",
        style:
            TextStyle(color: isSelected ? color ?? Colors.black : Colors.black),
      ),
    );
  }

  //Configure Firebase Push Notifications
  void configurePushNotification() {
    print("config Notification");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage $message");

        NotificationItem notification;
        if (isAndroid()) {
          var x = json.encode(message["data"]);
          var y = jsonDecode(x);
          notification = NotificationItem.fromJson(y);
        }
        // print("Cuurent Route ${ModalRoute.of(context).settings.name}");
        /* await  Navigator.of(context).popUntil((route) {
          print("Route first ${route.isFirst}");
          return route.isFirst;
        });*/
        notificationRedirection(notification);
      },
      onResume: (Map<String, dynamic> message) async {
        /*   await    Navigator.of(context).popUntil((route) {
          print("Route first ${route.isFirst}");
          return route.isFirst;
        });*/

        NotificationItem notification;
        if (isAndroid()) {
          var x = json.encode(message["data"]);
          var y = jsonDecode(x);
          notification = NotificationItem.fromJson(y);
        }
        notificationRedirection(notification);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch $message");
        NotificationItem notification;
        if (isAndroid()) {
          var x = json.encode(message["data"]);
          var y = jsonDecode(x);
          notification = NotificationItem.fromJson(y);
        }
        notificationRedirection(notification);
      },

//      onBackgroundMessage: (Map<String, dynamic> message) async {
//        print("onBackgroundMessage CALLED $message");
//        DashboardBloc dashboardBloc = new DashboardBloc();
//        dashboardBloc.updateCounter();
//      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

//
    _firebaseMessaging.getToken().then((String token) {
      print("DevToken ---> $token");
      sendToken(token);
      assert(token != null);
    });
  }

  notificationRedirection(NotificationItem item) async {
    print("Redirecting -->  ${item?.toJson()}");
    /*var x = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider(
          create: (BuildContext context) => NotificationBloc(
              notificationRepository: NotificationRepository()),
          child: NotificationScreen());
    }));
    */

    switch (item?.kind) {
      case NotificationType.prayAlong:
      case NotificationType.post:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new BlocProvider(
            create: (context) =>
                PrayerBloc(prayerRepository: PrayerRepository()),
            key: Key("key"),
            child: new PrayerDetailScreen(prayerId: item?.object),
          );
        }));
        break;
      case NotificationType.comment:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new BlocProvider(
            create: (context) =>
                PrayerBloc(prayerRepository: PrayerRepository()),
            key: Key("key"),
            child: new PrayerDetailScreen(
              prayerId: item?.object,
              isComment: true,
            ),
          );
        }));
        break;
      case NotificationType.badge:
        tabController?.animateTo(4);
        break;
      case NotificationType.group:
        tabController?.animateTo(1);
        break;
      case NotificationType.challenge:
        showAcceptChallengeSheet(item, context);
        break;
      default:
        print("not specified");
        break;
    }
  }

  setTabs() {
    tabChildren = isLoggedIn()
        ? [
            BlocProvider(
                create: (BuildContext context) =>
                    PrayerBloc(prayerRepository: PrayerRepository()),
                child: PrayersScreen(tabController: tabController)),
            BlocProvider(
                create: (BuildContext context) =>
                    GroupBloc(groupRepository: GroupRepository()),
                child: GroupListing()),
            BlocProvider(
              create: (context) =>
                  ChallengeBloc(repository: ChallengeRepository()),
              child: ChallengesScreen(),
            ),
            EventHome(),
            BlocProvider(
              create: (context) => ProfileBloc(repository: ProfileRepository()),
              key: Key("key"),
              child: new UserDetailScreen(
                userId: LoggedInUser?.user?.userId,
              ),
            ),
            // AboutMe(),
          ]
        : [
            BlocProvider(
                create: (BuildContext context) =>
                    PrayerBloc(prayerRepository: PrayerRepository()),
                child: PrayersScreen(tabController: tabController)),
            BlocProvider(
              create: (context) =>
                  ChallengeBloc(repository: ChallengeRepository()),
              child: ChallengesScreen(),
            ),
            EventHome(),
          ];

    bottomBarChildren = isLoggedIn()
        ? [
            NavigationBarItem(
                icon: Icons.menu,
                title: "PrayerBoard",
                image: AssetStrings.prayingHands,
                activeImage: AssetStrings.prayingHandActive),
            NavigationBarItem(
                icon: Icons.group,
                title: "Groups",
                image: AssetStrings.group,
                activeImage: AssetStrings.groupActive),
            NavigationBarItem(
                icon: Icons.favorite_border,
                title: "Home",
                image: AssetStrings.bible,
                activeImage: AssetStrings.bibleActive),
            NavigationBarItem(
                icon: Icons.card_travel,
                title: "Events",
                image: AssetStrings.event,
                activeImage: AssetStrings.eventActive),
            NavigationBarItem(
                icon: Icons.person_outline,
                title: "Profile",
                image: AssetStrings.user,
                activeImage: AssetStrings.userActive),
          ]
        : [
            NavigationBarItem(
                icon: Icons.menu,
                title: "Home",
                image: AssetStrings.prayingHands,
                activeImage: AssetStrings.prayingHandActive),
            NavigationBarItem(
                icon: Icons.favorite_border,
                title: "Daily Challenges",
                image: AssetStrings.bible,
                activeImage: AssetStrings.bibleActive),
            NavigationBarItem(
                icon: Icons.card_travel,
                title: "Events",
                image: AssetStrings.event,
                activeImage: AssetStrings.eventActive),
          ];
  }

  void sendToken(String token) {
    print("Sending token ");
    try {
      if (isLoggedIn() && (LoggedInUser.getUserDetail?.sendAlarm ?? false)) {
        ProfileRepository().registerPush(token: token);
      }
    } catch (e) {
      print("exceptions in token ");
    }
  }

  void setUpRevenueCat() async {
    if (isLoggedIn()) {
      print("id ==> ${LoggedInUser.user?.userId}");
      await RevenueKatServices.initPlatformState();
      await RevenueKatServices.identifyUser(
          id: LoggedInUser?.user?.userId?.toString());
    }
  }
}
