

import 'package:army120/features/notifications/data/model/notification.dart';
import 'package:flutter/foundation.dart';

abstract class NotificationState {}

class NotificationIdleState extends NotificationState {}

class FetchingNotificationState extends NotificationState {}

class FetchNotificationSuccessState extends NotificationState {
  List<NotificationItem> events;
//
  FetchNotificationSuccessState({@required this.events});
}

class NotificationErrorState extends NotificationState {
  String message;

  NotificationErrorState({this.message});
}
