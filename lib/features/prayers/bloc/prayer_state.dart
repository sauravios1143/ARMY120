import 'package:army120/features/prayers/data/model/comment.dart';
import 'package:army120/features/prayers/data/model/create_post_response.dart';
import 'package:army120/features/prayers/data/model/prayer.dart';
import 'package:flutter/foundation.dart';

abstract class PrayersState {}

class PrayersIdleState extends PrayersState {}

class FetchingPrayerState extends PrayersState {}

class FetchingCommentState extends PrayersState {}

class PrayersFetchSuccessState extends PrayersState {
  List<Prayer> prayer;

  PrayersFetchSuccessState({@required this.prayer});
}

class CommentFetchSuccessState extends PrayersState {
  List<Comments> comments;

  CommentFetchSuccessState({@required this.comments});
}

class PrayerDetailSuccessState extends PrayersState {
  Prayer prayer;

  PrayerDetailSuccessState({@required this.prayer});
}

class PrayerErrorState extends PrayersState {
  String message;
  bool isSuccess;

  PrayerErrorState({@required this.message});
}

class PrayerUpdatingState extends PrayersState {}

class PrayAlongSuccessState extends PrayersState {
  bool success;
  int id;

  PrayAlongSuccessState({this.success: false, this.id});
}

class PrayerCommentSuccess extends PrayersState {
  bool isSuccess;

  PrayerCommentSuccess({this.isSuccess});
}

class PrayerDeleteSuccessState extends PrayersState {
  bool isSuccess;

  PrayerDeleteSuccessState({this.isSuccess});
}

class PrayerReportSuccessState extends PrayersState {
  bool isSuccess;

  PrayerReportSuccessState({this.isSuccess});
}

class PrayerUpdateSuccessState extends PrayersState {
  bool isSuccess;

  PrayerUpdateSuccessState({this.isSuccess});
}

class CreateNewPostSuccess extends PrayersState {
  bool isSuccess;
  CreatePostResponse response;

  CreateNewPostSuccess({this.isSuccess, this.response});
}
