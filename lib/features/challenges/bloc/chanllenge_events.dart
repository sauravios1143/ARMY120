import 'dart:developer';
import 'dart:io';


import 'package:army120/features/challenges/data/model/custom_challenge_request.dart';
import 'package:army120/features/challenges/data/model/start_challenge_request.dart';
import 'package:army120/features/challenges/data/model/update_profile_request.dart';
import 'package:flutter/foundation.dart';

abstract class ChallengeEvent  {
  const ChallengeEvent();
}
class FetchChallengesEvent extends ChallengeEvent {}
class CreateCustomChallenge extends ChallengeEvent {
  CustomChallengeRequest request;
  CreateCustomChallenge({@required this.request});
}

class FetchGroupChallengeRequest extends ChallengeEvent {
  String identifier;
  FetchGroupChallengeRequest({this.identifier});
}
class FetchActiveChallengeEvent extends ChallengeEvent {}

class StartChallenge extends ChallengeEvent{
  StartChallengeRequest request;
  StartChallenge({this.request});
}
