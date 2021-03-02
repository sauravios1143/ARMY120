import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/events/data/model/create_event_response.dart';
import 'package:army120/features/events/data/model/event.dart';
import 'package:army120/features/notifications/data/model/notification.dart';
import 'package:flutter/foundation.dart';

abstract class HomeState {}

class HomeIdleState extends HomeState {}

class FetchingPatronState extends HomeState {}

class FetchingNotificationsState extends HomeState {}

class FetchingPatronSuccessState extends HomeState {
  List<User> patronList;

  FetchingPatronSuccessState({this.patronList});
}

class FetchingNotificationSuccessState extends HomeState {
  List<NotificationItem> notificatioinList;
  FetchingNotificationSuccessState({this.notificatioinList});
}

class HomeErrorState extends HomeState {
  String message;

  HomeErrorState({this.message});
}
