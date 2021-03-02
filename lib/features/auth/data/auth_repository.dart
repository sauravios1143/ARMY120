
import 'package:army120/features/auth/data/model/forgot_password_request.dart';
import 'package:army120/features/auth/data/model/login_request.dart';
import 'package:army120/features/auth/data/model/login_response.dart';
import 'package:army120/features/auth/data/model/signup_request.dart';
import 'package:army120/features/auth/data/model/signUpResponse.dart';
import 'package:army120/features/auth/data/model/forgot_response.dart';


import 'package:army120/network/apiError.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/utils/app_messages.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AuthRepository {

  Future<LoginResponse> login({@required LoginRequest request}) async {
    try {
      var response = await RestClient.dio.post(
          ApiURL.login, data: request?.toJson());
      if (response.statusCode == 200) {
        var data = response.data;
        LoginResponse loginResponse = LoginResponse.fromJson(data);
        print("Response got ${loginResponse?.toJson()}");
        return loginResponse;
      }else {
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

  // signup
  Future<SignUpResponse> signUp({@required SignUpRequest request}) async {
    try {
      var response =
      await RestClient.dio.post(ApiURL.signUp, data: request.toJson());
      if (response.statusCode == 200) {
        var data = response.data;
        SignUpResponse users = SignUpResponse.fromJson(data);
        return users;
      } else {
        throw ApiException(message:AppMessages?.commonError);

      }
    } catch (e) {
      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message:AppMessages?.commonError);

      }
    }
  }


  Future<ForgotPwdResponse> forgotPwd({@required ForgotPasswordRequest request }) async {
    try {
      var body=request?.toJson();
      var response = await RestClient.dio.post(
          ApiURL.forgotPwd, data: body);
      if (response.statusCode == 200) {
        var data = response.data;
//        ForgotPwdResponse _response = ForgotPwdResponse.fromJson(data);
//        print("Response got ${_response?.toJson()}");
        return ForgotPwdResponse();
      }else {
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