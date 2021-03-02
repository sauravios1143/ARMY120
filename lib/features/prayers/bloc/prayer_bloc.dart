import 'package:army120/features/prayers/bloc/prayer_event.dart';
import 'package:army120/features/prayers/bloc/prayer_state.dart';
import 'package:army120/features/prayers/data/prayer_repository.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayersState> {
  PrayerRepository prayerRepository;

  PrayerBloc({@required this.prayerRepository});

  @override
  PrayersState get initialState => PrayersIdleState();

  @override
  Stream<PrayersState> mapEventToState(PrayerEvent event) async* {
    print("Event $event");

    //Fetch prayer list
    if (event is FetchPrayers) {
      //Fetch prayer listing
      if (event?.currentPage == 0) {
        yield FetchingPrayerState();
      }
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await prayerRepository.fetchPrayers(
            currentPage: event?.currentPage);
        print("got x ${x.toJson()}");
        yield PrayersFetchSuccessState(prayer: x?.data);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    //fetch user prayers
    if (event is FetchMyPrayers) {
      //Fetch prayer listing
      if (event?.currentPage == 0) {
        yield FetchingPrayerState();
      }
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await prayerRepository.fetchUserPrayers(
            currentPage: event?.currentPage, userId: event?.userId);
        print("got x ${x.toJson()}");
        yield PrayersFetchSuccessState(prayer: x?.data);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    //fetch Prayer by group
    if (event is FetchPrayersOfGroup) {
      //Fetch prayer listing

      if(event.page==0){
        yield FetchingPrayerState();
      }

      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await prayerRepository.fetchPrayerOfGroup(
            page: event?.page, groupId: event?.groupId);
        print("got x ${x.toJson()}");
        yield PrayersFetchSuccessState(prayer: x?.data);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    //Fetch Prayer Detail
    if (event is FetchPrayerDetail) {
      if (!(event?.isSilent ?? false)) {
        yield FetchingPrayerState();
      }
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }
        if(event?.isComment??false){
          var x =
          await prayerRepository.fetchPrayerDetailByComment(commentId: event?.prayerId);
          print("got x ${x.toJson()}");
          yield PrayerDetailSuccessState(prayer: x?.data?.post);
        }else{
          var x =
          await prayerRepository.fetchPrayerDetail(prayerId: event?.prayerId);
          print("got x ${x.toJson()}");
          yield PrayerDetailSuccessState(prayer: x?.data);
        }



      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    // Create new Post
    if (event is CreateNewPost) {
      yield PrayerUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await prayerRepository.createNewPost(request: event?.post);

        yield CreateNewPostSuccess(isSuccess: true, response: x);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

/*    // Create new group Post
    if (event is CreateNewGroupPost) {
      yield PrayerUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }
        var x =
            await prayerRepository.createNewPostToGroup(request: event?.post);

        yield CreateNewPostSuccess(isSuccess: true, response: x);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }*/

    //Update Post
    if (event is UpdatePost) {
      yield PrayerUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await prayerRepository.updatePost(
            request: event?.post, postId: event?.postId);

        yield PrayerUpdateSuccessState();
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    //Report Post
    if (event is ReportPost) {
      yield PrayerUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await prayerRepository.reportPost(postId: event?.postId);

        yield PrayerReportSuccessState(isSuccess: x ?? false);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    //Delete Post
    if (event is DeletePost) {
      yield PrayerUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await prayerRepository.deletePost(prayerId: event?.postId);

        yield PrayerDeleteSuccessState(isSuccess: x ?? false);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    // Pray along
    if (event is PrayAlong) {
//      yield PrayerUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await prayerRepository.prayAlong(id: event.id);

        yield PrayAlongSuccessState(success: true, id: event.id);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    //fetch comment list
    if (event is FetchComments) {
      //Fetch prayer listing
      yield FetchingCommentState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await prayerRepository.fetchComments(
            prayreId: event?.payerId, page: event?.currentPage);
        print("got x ${x.toJson()}");
        yield PrayersFetchSuccessState(prayer: x?.data);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    //Comment on prayer
    if (event is CommentOnPrayer) {
      // yield PrayerUpdatingState();todo
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }

        Map body = {"text": "${event.comment}"};
        var x = await prayerRepository.addComment(
            prayerId: event?.prayerId, body: body);

        yield PrayerCommentSuccess(isSuccess: x ?? false);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    //Delete Comment
    if (event is DeleteComment) {
      yield PrayerUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }
        var x =
            await prayerRepository.deleteComment(commentId: event?.commentId);

        yield PrayerCommentSuccess(isSuccess: x ?? false);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }

    //ReportComment
    if (event is ReportComment) {
      yield PrayerUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield PrayerErrorState(message: AppMessages.noInternet);
          return;
        }

        var x =
            await prayerRepository.reportComment(commentId: event?.commentId);

        yield PrayerCommentSuccess(isSuccess: x ?? false);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield PrayerErrorState(message: e.toString());
      }
    }
  }
}
