
import 'dart:convert';
import 'dart:io';

import 'package:army120/features/challenges/data/model/categoryl_listing_response.dart';
import 'package:army120/features/challenges/data/model/custom_challenge_request.dart';
import 'package:army120/features/challenges/data/model/group_challenge_request_response.dart';
import 'package:army120/features/challenges/data/model/start_challenge_request.dart';
import 'package:army120/features/challenges/data/model/update_profile_request.dart';
import 'package:army120/features/challenges/data/model/update_profile_response.dart';
import 'package:army120/network/apiError.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'model/active_challenge_esponse.dart';

class ChallengeRepository {
  
  Future<bool> startChallenge(
      {@required StartChallengeRequest request}) async {
    try {
      var response =
          await RestClient.dio.post(ApiURL.startChallenge, data: request?.toJson());
      if (response.statusCode == 200) {
        var data = response.data;
        UpdatePrfileResponse loginResponse =
            UpdatePrfileResponse.fromJson(data);
        print("Response got ${loginResponse?.toJson()}");
       return true;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }

  //create custom Challenge
  Future<bool> createCustomChallenge(
      {@required CustomChallengeRequest request}) async {
    try {
      var response =
          await RestClient.dio.post(ApiURL.startChallenge, data: request?.toJson());
      if (response.statusCode == 200) {
        var data = response.data;
        UpdatePrfileResponse loginResponse =
            UpdatePrfileResponse.fromJson(data);
        print("Response got ${loginResponse?.toJson()}");
       return true;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }


  //fetch challenges
  Future<CategoryListingResponse> fetchChallenges() async {
    try {
      var response = await RestClient.dio.get(ApiURL.fetchChallenges);
      if (response.statusCode == 200) {
        var data = response.data;
//        print("data -----> ${data}");
        debugPrint("debug ----> ${jsonEncode(response?.data)}",wrapWidth:1024);
        CategoryListingResponse prayersResponse = CategoryListingResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }  catch (e,st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);

      }else{
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }

  //fetch challenges
  Future<ActivePrayerChallenge> fetchActiveChallenge() async {
    try {
      var response = await RestClient.dio.get(ApiURL.dailyPrayer);
      if (response.statusCode == 200) {
        var data = response.data;
//        print("data -----> ${data}");
        debugPrint("debug ----> ${jsonEncode(response?.data)}",wrapWidth:1024);
        ActivePrayerChallenge prayersResponse = ActivePrayerChallenge.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }  catch (e,st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);

      }else{
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }  //fetch challenges

  //fetch challenge request
  Future<GroupChallengeRequestResponse> fetchGroupChallengeRequest({@required String identifier}) async {
    try {
      var response = await RestClient.dio.get(ApiURL.dailyPrayerGroupRequest+"/${identifier}");
      if (response.statusCode == 200) {
        var data = response.data;
//        print("data -----> ${data}");
        debugPrint("debug ----> ${jsonEncode(response?.data)}",wrapWidth:1024);
        GroupChallengeRequestResponse prayersResponse = GroupChallengeRequestResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }  catch (e,st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      }else{
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }
}
