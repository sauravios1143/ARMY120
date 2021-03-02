import 'package:army120/features/notifications/bloc/notification_bloc.dart';
import 'package:army120/features/notifications/bloc/notification_event.dart';
import 'package:army120/features/notifications/bloc/notification_state.dart';
import 'package:army120/features/notifications/data/model/notification.dart';
import 'package:army120/features/notifications/data/notification_repository.dart';
import 'package:army120/features/notifications/ui/notification_screen.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/Constants/notifcation_type.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationListingView extends StatefulWidget {
  @override
  _NotificationListingViewState createState() =>
      _NotificationListingViewState();
}

class _NotificationListingViewState extends State<NotificationListingView> {
  bool gotData = false;
  List<NotificationItem> notificationList = [];
  NotificationBloc _notificationBloc;

//Getters
  Widget get getViewAllButton {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlocProvider(
                create: (BuildContext context) => NotificationBloc(
                    notificationRepository: NotificationRepository()),
                child: NotificationScreen());
          }));
        },
        child: Text(
          "View All",
          style: TextStyle(
              color: AppColors.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //notificaitn list
  Widget get getNotification {
    return notificationList?.isEmpty
        ? Text("No notification found")
        : Column(
            children: [
              getNotificationList,
              getViewAllButton,
            ],
          );
  }

  Widget get getNotificationList {
    return Column(
      children: List.generate(notificationList?.length,
          (index) => getNotificationItem(notificationList[index])),
    );
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

            _child = getNotification;
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
            _child = getNotification;
          }

          return _child;
        },
      );
    });
  }

  //State Methods
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
    return Stack(
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
    );
  }

  // notification item
  Widget getNotificationItem(NotificationItem item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.ultraLightBGColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
         Text("dd")
        ],
      ),
    );
  }

  //set notification data
  setNotificationData(FetchNotificationSuccessState state) {
    notificationList = state?.events;
    gotData = true;
  }

  //fetch notifications
  fetchNotifications() {
    _notificationBloc.add(FetchNotifications());
  }


}
