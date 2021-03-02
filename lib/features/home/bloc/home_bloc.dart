import 'package:army120/features/home/bloc/home_event.dart';
import 'package:army120/features/home/bloc/home_state.dart';
import 'package:army120/features/home/data/home_repository.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository homeRepository;

  HomeBloc({@required this.homeRepository});

  @override
  HomeState get initialState => HomeIdleState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    print("Event $event");

    if (event is FetchPatrons) {
      if (event.currentPage == 1) yield FetchingPatronState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield HomeErrorState(message: AppMessages.noInternet);
          return;
        }
        var x =
            await homeRepository.fetchPatrons(currentPage: event.currentPage);

        yield FetchingPatronSuccessState(patronList: x?.data?.patrons);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield HomeErrorState(message: e.toString());
      }
    }
    if (event is FetchNotifications) {
      yield FetchingNotificationsState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield HomeErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await homeRepository.fetchNotifications();

        yield FetchingNotificationSuccessState(
            notificatioinList: x?.data?.notifications);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield HomeErrorState(message: e.toString());
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
//eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJlbWFpbCI6ImRldjFAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiRGV2In0.KvpweuDuuMH01tpHhFaPIUpOOQA-EklEKHepVOr4HEEb53CEEp1WTgBScLY7wBmkKRnwjw4S_ICH-i89VxwJjXoR5cdHg_XUei1LclkDoG1VbS9UoLSz4Gkk6upRvmpKskbCfGU8aNyOnBiFSNKDddwcWCU2FmuBOBpN-w1TLx0jXV8_6XGrT7Bq8wnTJGBR7XQ7uIjE9cYmhUZoRlEND-BTOyE0WOjHZUukj9lMwFDHWgFpGLE9l4zIwZFFDXqTCLC0N8tVaCqeIoyhgO4ztAnfAhyMxNxAgJ1nby7pHSbIwIitqhW-dfvo5A-X9ruxuYIlnms3avYT3zGELlwVcg
