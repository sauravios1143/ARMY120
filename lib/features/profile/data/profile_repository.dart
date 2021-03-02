import 'dart:convert';
import 'package:army120/features/auth/data/model/profile_ficture.dart';
import 'package:army120/features/auth/data/model/user_detail.dart';
import 'package:army120/features/auth/data/model/user_detail_response.dart';
import 'package:army120/features/profile/data/model/media_signature_response.dart';
import 'package:army120/features/profile/data/model/notificaton_model.dart';
import 'package:army120/features/profile/data/model/push_request.dart';
import 'package:army120/features/profile/data/model/update_profile_request.dart';
import 'package:army120/features/profile/data/model/update_profile_response.dart';
import 'package:army120/network/apiError.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/network/fileUpload.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:army120/utils/memory_management.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ProfileRepository {

  FileUpload _uploadMethod= new FileUpload();

  Future<UpdateProfileResponse> updateUserDetail(
      {@required UpdateProfileRequest request}) async {
    try {
      if(request?.file!=null){

        MediaSignatureResponse mediaSignatureResponse =
        await _uploadMethod.mediaSignature(file:request?.file);

        if (mediaSignatureResponse != null) {
        ProfilePicture uploadReponse =   await _uploadMethod.uploadFile(
              file: request?.file, mediaSignatureResponse: mediaSignatureResponse);
        request.profilePicture=uploadReponse;
        } else {
          throw ApiException(message: "Unable to upload file ");
        }
      //
        //
        // todo remmove

        // request.profilePicture =ProfilePicture(
        //   url: "url.png",
        //    kind:  "png",
        //   thumbnailUrl: "url.png"
        // );

      }

/*
      var data ={
        "gender" :"male",
        "dateOfBirth" :1605972746,
        "phone" :"9805555555",
        "about" :"about",
        "profilePicture" :ProfilePicture().toJson()


      };*/

      var response = await RestClient.dio.patch(
          ApiURL.updateProfile + "/${LoggedInUser.user.userId}",
          data: ((request?.currentStep??"").isNotEmpty)?request?.toJsonByStep(request.currentStep): request?.toJson());
      if (response.statusCode == 200) {
        var data = response.data;
        UpdateProfileResponse loginResponse =
        UpdateProfileResponse.fromJson(data);

        await setProfileData(loginResponse?.data);
        print("Response got ${loginResponse?.toJson()}");
        return loginResponse;
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

  //update Push notifications
  Future<bool> updatePush(
      {@required PushRequest request}) async {
    try {
      var response = await RestClient.dio.post(
          ApiURL.updatePush ,
          data:  request?.toJson());
      if (response.statusCode == 200) {
       /* var data = response.data;
        UpdateProfileResponse loginResponse =
        UpdateProfileResponse.fromJson(data);

        await setProfileData(loginResponse?.data);
        print("Response got ${loginResponse?.toJson()}");
        return loginResponse;*/
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
  //update Push notifications

  Future<PushResponse> getPushStatus() async {
    try {
      var response = await RestClient.dio.get(
          ApiURL.updatePush );
      if (response.statusCode == 200) {
        var data = response.data;
        PushResponse loginResponse =
        PushResponse.fromJson(data);
        return loginResponse;
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



  //get user detail
  Future<UserDetailResponse> getUserDetail() async {
    try {
      var userId = LoggedInUser.user?.userId;
      var response = await RestClient.dio.get(ApiURL.userDetail + "/${userId}");

      if (response.statusCode == 200) { //todo got issue here
        var data = response.data;
        print("data ");
        UserDetailResponse userDetailResponse = UserDetailResponse.fromJson(data);
        print("Response got ${userDetailResponse?.toJson()}");
        await setProfileData(userDetailResponse?.data);
        return userDetailResponse;
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
  }  //get user detail
  Future<UserDetailResponse> getOtherUserDetail({userId}) async {
    try {
      var response = await RestClient.dio.get(ApiURL.userDetail + "/${userId}");

      if (response.statusCode == 200) { //todo got issue here
        var data = response.data;
        print("data ");
        UserDetailResponse userDetailResponse = UserDetailResponse.fromJson(data);
        print("Response got ${userDetailResponse?.toJson()}");
        return userDetailResponse;
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

  //set profile data
  setProfileData(UserDetail detail)async{
    print("user detail --> ${detail?.firstName}");
    await MemoryManagement.setUserDetail(userInfo: jsonEncode(detail));
    if(detail.profileCompletion?.completion ==100){
      MemoryManagement.setIsProfileCompleted(isProfileCompleted: true);
    }
    LoggedInUser.setUserDetail = detail;
  }

  //logout
  Future<bool> logout({String token}) async {
    try {
      Map<String,dynamic> map = {
        "device": {
          "token": token
        }
      };
      var response = await RestClient.dio.post(ApiURL.logout,data: map);

      if (response.statusCode == 200) { //todo got issue here
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


  //logout
  Future<bool> registerPush({String token}) async {
    try {
      Map<String,dynamic> map = {
        "token": token??"",
        "platform":"android"
      };
      var response = await RestClient.dio.post(ApiURL.device,data: map);

      if (response.statusCode == 200) { //todo got issue here
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
}
