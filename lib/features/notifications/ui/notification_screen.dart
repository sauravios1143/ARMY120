import 'package:army120/features/challenges/bloc/challenge_bloc.dart';
import 'package:army120/features/challenges/data/challenge_repository.dart';
import 'package:army120/features/challenges/ui/accept_group_challenge.dart';
import 'package:army120/features/notifications/bloc/notification_bloc.dart';
import 'package:army120/features/notifications/bloc/notification_event.dart';
import 'package:army120/features/notifications/bloc/notification_state.dart';
import 'package:army120/features/notifications/data/model/notification.dart';
import 'package:army120/features/prayers/bloc/prayer_bloc.dart';
import 'package:army120/features/prayers/data/prayer_repository.dart';
import 'package:army120/features/prayers/ui/prayer_detail.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/Constants/notifcation_type.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/reusableWidgets/paginationLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool gotData = false;
  List<NotificationItem> notificationList = [];
  NotificationBloc _notificationBloc;
  int currentPage = 1;
  int perPageCount = 1;
  ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isLoading = new ValueNotifier<bool>(false);
  GlobalKey <ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //notificaitn list
  Widget get getNotificationList {
    return notificationList?.isEmpty
        ? getNoDataView(
            msg: "No notification found",
            onRetry: () {
              fetchNotifications();
            })
        : ListView.separated(
            // controller: _scrollController,todo
            padding: EdgeInsets.only(bottom: 60, left: 12, right: 12, top: 12),
            itemBuilder: (context, index) {
              return index == notificationList.length
                  ? PaginationLoader(
                      loaderNotifier: isLoading,
                    )
                  : getNotificationItem(notificationList[index]);
            },
            separatorBuilder: (context, index) {
              return getSpacer(height: 7);
            },
            itemCount: notificationList.length + 1);
  }

  //builder
  Widget get getNotificationView {
    return BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
      return Builder(
        builder: (context) {
          Widget _child;
          if (state is FetchNotificationSuccessState) {
            setNotificationData(state);

            _child = getNotificationList;
          } else if (state is FetchingNotificationState ||
              state is NotificationIdleState) {
            _child = CustomLoader();
          } else if (state is NotificationErrorState && !gotData) {
            _child = getNoDataView(
                msg: state?.message,
                onRetry: () {
                  fetchNotifications();
                });
          } else {
            _child = getNotificationList;
          }

          return _child;
        },
      );
    });
  }

  //State Methods

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_paginationLogic);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!gotData) {
      _notificationBloc = BlocProvider.of<NotificationBloc>(context);
      fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: getAppThemedAppBar(context, titleText: "Notifications"),
      body: Stack(
        children: [
          getNotificationView,
          BlocListener<NotificationBloc, NotificationState>(
              child: Container(
                height: 0,
                width: 0,
              ),
              listener: (context, state) async {
                if (state is NotificationErrorState) {
                  showAlert(
                      context: context,
                      titleText: "Error",
                      message: state?.message ?? "",
                      actionCallbacks: {"Ok": () {}});
                }
              })
        ],
      ),
    );
  }

  // notification item
  Widget getNotificationItem(NotificationItem item) {
    return InkWell(
      onTap: () {
        onNotificationTap(item);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: AppColors.ultraLightBGColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Image.asset(
              getAssetIcon(item?.kind),
              height: 30,
              width: 30,
            ),
            getSpacer(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  getSpacer(width: 6),
                  Text(
                    item.text ?? "",
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  //other methods

  //set notification data
  setNotificationData(FetchNotificationSuccessState state) {
    gotData = true;
    isLoading.value = false;
    if (currentPage == 1) {
      notificationList = state?.events;
      perPageCount = state?.events?.length ?? 0;
    } else {
      notificationList.addAll(state?.events);
    }
  }

  //fetch notifications
  fetchNotifications() {
    _notificationBloc.add(FetchNotifications(currentPage: currentPage));
  }

  //pagination logic
  _paginationLogic() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      print("totalRecode ${notificationList?.length} " +
          "current page ${currentPage}  perpageCount ${perPageCount}");

      print("Paginatig");
      if ((notificationList?.length ?? 0) >=
          (perPageCount * currentPage ?? 0)) {
        if (!isLoading.value) //is not loading
        {
          isLoading.value = true;
          currentPage++;
          fetchNotifications();
        }
      }
    }
  }

  String getAssetIcon(String icon) {
    String value;
    switch (icon) {
      case NotificationType.prayAlong:
      case NotificationType.post:
        value = AssetStrings.prayingHandActive;
        break;
      case NotificationType.badge:
        value = AssetStrings.ribbon;
        break;
      case NotificationType.challenge:
        value = AssetStrings.bibleActive;
        break;
        case NotificationType.group:
        value = AssetStrings.groupActive;
        break;case NotificationType.comment:
        value = AssetStrings.prayingHandActive;
        break;
      default:
        value = AssetStrings.notification;
    }
    return value;
  }

  void onNotificationTap(NotificationItem item) {
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
            child: new PrayerDetailScreen(prayerId: item?.object,isComment: true,),
          );
        }));
        break;
      case NotificationType.badge:
        Navigator.pop(context, 4);
        break;
        case NotificationType.group:
        Navigator.pop(context, 1);
        break;
      case NotificationType.challenge:
        showAcceptChallengeSheet(item,context);
        break;
      default:
    }
  }
}
