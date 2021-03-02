
import 'package:army120/features/events/data/model/event.dart';
import 'package:army120/features/events/data/model/new_event_request.dart';
import 'package:flutter/foundation.dart';

//Event Events
abstract class EventsEvent {
  const EventsEvent();
}

//Fetch Event list
class FetchEvent extends EventsEvent {
//  const FetchEvent();
}
//Fetch Event list
class BookmarkEvent extends EventsEvent {
 Event event;
 BookmarkEvent({this.event});
}

//fetch Event detail
class FetchEventDetail extends EventsEvent {
  int eventId;

  FetchEventDetail({@required this.eventId});
}


//create new post
class CreateNewEvent extends EventsEvent {
  NewEventRequest request;

  CreateNewEvent({@required this.request});
}
//create new post
