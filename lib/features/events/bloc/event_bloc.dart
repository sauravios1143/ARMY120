
import 'package:army120/features/events/bloc/event_event.dart';
import 'package:army120/features/events/bloc/event_state.dart';
import 'package:army120/features/events/data/event_repository.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventBloc extends Bloc<EventsEvent, EventState> {
  EventRepository eventRepository;

  EventBloc({@required this.eventRepository});

  @override
  EventState get initialState => EventIdleState();

  @override
  Stream<EventState> mapEventToState(EventsEvent event) async* {
    print("Event $event");


    // Create new Post
    if (event is FetchEvent) {

      //Fetch prayer listing
      yield FetchingEventState();

      try {
        bool isConnected =
        await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield EventErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await eventRepository.fetchEvents();
        print("got x ${x.toJson()}");
        yield EventFetchSuccessState(events: x?.data);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield EventErrorState(message: e.toString());
      }
    }

    // Create new Post
    if (event is BookmarkEvent) {


//      yield EventUpdatingState();

      try {
        bool isConnected =
        await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield EventErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await eventRepository.bookMarkEvent(event: event?.event);
//        print("got x }");
        yield BookMarkSuccess();
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield EventErrorState(message: e.toString());
      }
    }

//    if (event is CreateNewEvent) {
//      yield EventUpdatingState();
//      try {
//        var x = await eventRepository.createNewEvent(request: event?.request);
//
//        yield CreateNewEventSuccess(response:x);
//      } catch (e, st) {
//        print("Exception $e, \n$st");
//        //todo
//        yield EventErrorState(message: e.toString());
//      }
//    }
  }
}
