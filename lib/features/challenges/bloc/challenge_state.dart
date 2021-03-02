import 'package:army120/features/challenges/data/model/active_challenge_esponse.dart';
import 'package:army120/features/challenges/data/model/category.dart';
import 'package:army120/features/challenges/data/model/group_challenge_request_response.dart';
import 'package:army120/features/challenges/data/model/start_challenge_request.dart';
import 'package:army120/features/challenges/data/model/update_profile_response.dart';
import 'package:flutter/foundation.dart';

abstract class ChallengeState {}

//
class ChallengeIdleState extends ChallengeState {}

class FetchingChallengeState extends ChallengeState {}
class ChallengeUpdatingState extends ChallengeState {}

class FetchChallengeSuccessState extends ChallengeState {
  List<Categories> categoryList;

  FetchChallengeSuccessState({this.categoryList});
}
class FetchActiveChallengeSuccessState extends ChallengeState {
  ActiveChallenge activeChallege;

  FetchActiveChallengeSuccessState({this.activeChallege});
}
class FetchGroupChallengeRequestSuccess extends ChallengeState {
  RequestData groupRequest;

  FetchGroupChallengeRequestSuccess({this.groupRequest});
}



class StartChallengeSuccessState extends ChallengeState {

  StartChallengeSuccessState();
}

class ChallengeErrorState extends ChallengeState {
  String message;

  ChallengeErrorState({@required this.message});
}
