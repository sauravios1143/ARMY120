
import 'package:army120/features/notifications/bloc/notification_event.dart';
import 'package:army120/features/notifications/bloc/notification_state.dart';
import 'package:army120/features/notifications/data/notification_repository.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationRepository notificationRepository;

  NotificationBloc({@required this.notificationRepository});

  @override
  NotificationState get initialState => NotificationIdleState();

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    print("Event $event");


    // Create new Post
    if (event is FetchNotifications) {

      //Fetch prayer listing
      yield FetchingNotificationState();

      try {
        bool isConnected =
        await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield NotificationErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await notificationRepository.fetchNotifications(
          currentPage: event.currentPage,
        );
        print("got x ${x.toJson()}");
        yield FetchNotificationSuccessState(events: x.data?.notifications);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield NotificationErrorState(message: e.toString());
      }

    }


  }
}
