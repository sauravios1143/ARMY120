import 'package:army120/features/auth/data/model/profile_ficture.dart';
import 'package:army120/features/profile/data/model/media_signature_response.dart';
import 'package:army120/network/apiError.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/network/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
class FileUpload{
  static BaseOptions _baseOptions = new BaseOptions(
    connectTimeout: 1000000,
      receiveTimeout: 1000000,
      headers: {
        "Connection":"keep-alive",
        "Content-Type":"multipart/form-data"
      }
  );

  Dio _dio= Dio(
    _baseOptions
  );

  Future<MediaSignatureResponse> mediaSignature({File file}) async {
    String name =file?.path?.split("/")?.last;

    var data = {"filename": name??""};
/*    await FormData.fromMap(
        {"filename": await MultipartFile?.fromFile(file?.path)});*/
    var response =
    await RestClient.dio.post(ApiURL.profileUploadUrl, data: data);

    if (response.statusCode == 200) {
      var data = response.data;
      MediaSignatureResponse mediaSignatureResponse =
      MediaSignatureResponse.fromJson(data);
      print("data ----> ${data}");
      return mediaSignatureResponse;
    } else {
      throw Exception();
    }
  }

  //upload profile
  Future<ProfilePicture> uploadFile(
      {@required File file,
        MediaSignatureResponse mediaSignatureResponse}) async {
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
    ));
    try {
      Map<String, dynamic> data = {};
      for (var x in mediaSignatureResponse?.formData) {
        print("---> ${x.key} : ${x.value}");
        data[x.key] = x.value;
      }
      var formData = await FormData.fromMap(data
        ..addAll({"file": await MultipartFile?.fromFile(file?.path)})

      );
      print("len---->${formData?.fields}");
//      Dio customDio =  Dio();
      var response = await _dio.post(
        mediaSignatureResponse?.formPostUrl,
          // "https://army120-uploads.s3.amazonaws.com",



          data: formData,); //customDio

      print("---resp");

      if (response.statusCode == 204) {
        var data = response.data;
        print("data ----> ${data}");
        return ProfilePicture(
          url: mediaSignatureResponse?.url,
          thumbnailUrl: mediaSignatureResponse?.thumbnailUrl,
          kind: mediaSignatureResponse?.kind,
        );

      } else {
        throw Exception();
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError && e.type == DioErrorType.RESPONSE) {
        print("got api Eorror");
        var data = e.response.data;
        throw ApiException(message: data['message']);
      } else {
        throw e;
      }
    }
  }
}