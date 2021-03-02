
import 'package:army120/features/events/data/model/event.dart';
import 'package:army120/features/events/data/model/new_event_request.dart';
import 'package:flutter/foundation.dart';

//Event Events
abstract class HomeEvent {
  const HomeEvent();
}

//Fetch Event list
class FetchPatrons extends HomeEvent {
  int currentPage;
  FetchPatrons({this.currentPage});
//  const FetchEvent();
}
//Fetch Event list
class FetchNotifications extends HomeEvent {
//  const FetchEvent();
}

