
import 'package:army120/features/events/data/model/create_event_response.dart';
import 'package:army120/features/events/data/model/event.dart';
import 'package:flutter/foundation.dart';

abstract class EventState {}

class EventIdleState extends EventState {}

class FetchingEventState extends EventState {}

class EventFetchSuccessState extends EventState {
  List<Event> events;
//
  EventFetchSuccessState({@required this.events});
}
class EventUpdatingState extends EventState{

}

class CreateNewEventSuccess extends EventState {
  CreateEventResponse response;

  CreateNewEventSuccess({this.response});
}
class BookMarkSuccess extends EventState {

}



class EventErrorState extends EventState {
  String message;

  EventErrorState({this.message});
}
