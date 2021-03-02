
import 'package:army120/features/events/data/model/event.dart';
import 'package:army120/features/events/data/model/new_event_request.dart';
import 'package:flutter/foundation.dart';

//Event Events
abstract class NotificationEvent {
  const NotificationEvent();
}

//Fetch Event list
class FetchNotifications extends NotificationEvent {
  int currentPage;
  FetchNotifications({this.currentPage});
//  const FetchEvent();
}


