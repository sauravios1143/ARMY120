import 'package:army120/features/prayers/data/model/new_post_request.dart';
import 'package:army120/features/auth/data/model/signup_request.dart';
import 'package:flutter/foundation.dart';

//Prayer Events
abstract class PrayerEvent {
  const PrayerEvent();
}

//Fetch prayer list
class FetchPrayers extends PrayerEvent {
  int currentPage;

  FetchPrayers({this.currentPage});
}

//Fetch prayer list
class FetchMyPrayers extends PrayerEvent {
  int currentPage;
  int userId;

  FetchMyPrayers({this.currentPage, this.userId});
}

//Fetch prayer list
class FetchComments extends PrayerEvent {
  int payerId;

  int currentPage;

  FetchComments({this.currentPage, this.payerId});
}

//Fetch prayer list
class FetchPrayersOfGroup extends PrayerEvent {
  int groupId;
  int page;

  FetchPrayersOfGroup({this.groupId, this.page});
}

//fetch prayer detail
class FetchPrayerDetail extends PrayerEvent {
  int prayerId;
  bool isSilent;
  bool isComment;

  FetchPrayerDetail({@required this.prayerId, this.isSilent, this.isComment:false});
}

//comment on existing post
class CommentOnPrayer extends PrayerEvent {
  int prayerId;
  String comment;

  CommentOnPrayer({@required this.prayerId, @required this.comment});
}

class DeletePost extends PrayerEvent {
  int postId;

  DeletePost({@required this.postId});
}class ReportPost extends PrayerEvent {
  int postId;

  ReportPost({@required this.postId});
}

class DeleteComment extends PrayerEvent {
  int commentId;

  DeleteComment({@required this.commentId});
}

//report comment
class ReportComment extends PrayerEvent {
  int commentId;

  ReportComment({@required this.commentId});
}

//create new post
class CreateNewPost extends PrayerEvent {
  NewPostRequest post;

  CreateNewPost({@required this.post});
}

//create new post
class UpdatePost extends PrayerEvent {
  NewPostRequest post;
  int postId;

  UpdatePost({@required this.post, this.postId});
}

//create new post
class CreateNewGroupPost extends PrayerEvent {
  NewPostRequest post;

  CreateNewGroupPost({@required this.post});
}

//pray along
class PrayAlong extends PrayerEvent {
  int id;

  PrayAlong({@required this.id});
}
