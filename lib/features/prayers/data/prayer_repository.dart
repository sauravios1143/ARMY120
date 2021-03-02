import 'dart:convert';

import 'package:army120/features/prayers/data/model/create_post_response.dart';
import 'package:army120/features/prayers/data/model/new_post_request.dart';
import 'package:army120/features/prayers/data/model/prayerResponse.dart';
import 'package:army120/features/prayers/data/model/prayer_by_comment_response.dart';
import 'package:army120/features/prayers/data/model/prayer_detail_response.dart';
import 'package:army120/network/apiError.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class PrayerRepository {
  //fetch Prayer Listing
  Future<PrayersResponse> fetchPrayers({currentPage}) async {
    try {
      var response = await RestClient.dio
          .get(ApiURL.getPrayerListing + "?page=${currentPage ?? 1}");
      if (response.statusCode == 200) {
        var data = response.data;
        PrayersResponse prayersResponse = PrayersResponse.fromJson(data);
        return prayersResponse;
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
  } //fetch Prayer Listing

  //Fetch user Prayer
  Future<PrayersResponse> fetchUserPrayers({currentPage, userId}) async {
    try {
      var response = await RestClient.dio.get(
          ApiURL.getUserPrayer + "/${userId}/posts?page=${currentPage ??0}");
      if (response.statusCode == 200) {
        var data = response.data;
        PrayersResponse prayersResponse = PrayersResponse.fromJson(data);
        return prayersResponse;
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

  //fetch Prayer by Group oid
  Future<PrayersResponse> fetchPrayerOfGroup({int groupId, int page: 0}) async {
    try {
      var response = await RestClient.dio.get(ApiURL.getPrayerListing +
          "?page=${page ?? 1}&group=${groupId ?? ""}");
      if (response.statusCode == 200) {
        var data = response.data;
        PrayersResponse prayersResponse = PrayersResponse.fromJson(data);
        return prayersResponse;
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

  //fetch Prayer Detial
  Future<PrayerDetailResponse> fetchPrayerDetail(
      {@required int prayerId}) async {

    try {
      var response = await RestClient.dio.get(
         ApiURL.post + "/$prayerId"
      );
      if (response.statusCode == 200) {
        var data = response.data;
        PrayerDetailResponse prayersResponse =
            PrayerDetailResponse.fromJson(data);
        return prayersResponse;
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
  }  //fetch
  // Prayer Detial by comment
  Future<PrayerByCommentResponse> fetchPrayerDetailByComment(
      {@required int commentId}) async {
    
    try {
      var response = await RestClient.dio.get(
         // ApiURL.post + "/$prayerId"
        ApiURL.comment+"/${commentId}/post"
      );
      if (response.statusCode == 200) {
        var data = response.data;
        PrayerByCommentResponse prayersResponse =
        PrayerByCommentResponse.fromJson(data);
        return prayersResponse;
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

/*  //fetch Prayer Detail
  Future<CreatePostResponse> createNewPostToGroup(
      {@required NewPostRequest request}) async {
    try {
      var response = await RestClient.dio
          .post(ApiURL.createNewPost, data: request.toGroupPostJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        //todo parcse data
        CreatePostResponse prayersResponse = CreatePostResponse.fromJson(data);
        return prayersResponse;
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
  }*/

  //Delete post
  Future<bool> deletePost({@required int prayerId}) async {
    try {
      var response = await RestClient.dio.delete(
        ApiURL.post + "/${prayerId}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return true; //todo verify
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
  } //Delete post

  //report post
  Future<bool> reportPost({@required int postId}) async {
    try {
      var response = await RestClient.dio.post(
        ApiURL.post + "/${postId}/report",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return true; //todo verify
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

  //pray along
  Future<bool> prayAlong({@required int id}) async {
    try {
      var response = await RestClient.dio.post(
        ApiURL.prayAlong + "/${id}/prayAlongs",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return true; //todo verify
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

  //fetch comments
  Future<PrayersResponse> fetchComments({int prayreId, int page: 1}) async {
    try {
      var response = await RestClient.dio
          .get(ApiURL.getComments + "/${prayreId}/comments");
      if (response.statusCode == 200) {
        var data = response.data;
        PrayersResponse prayersResponse = PrayersResponse.fromJson(data);
        return prayersResponse;
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

  //fetch Prayer Detial
  Future<bool> addComment({@required int prayerId, @required body}) async {
    try {
      var response = await RestClient.dio
          .post(ApiURL.addComment + "/$prayerId" + "/comments", data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
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

  //create new Post
  Future<CreatePostResponse> createNewPost(
      {@required NewPostRequest request}) async {
    try {
      var response = await RestClient.dio
          .post(ApiURL.createNewPost, data: request.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        //todo parcse data
        CreatePostResponse prayersResponse = CreatePostResponse.fromJson(data);
        return prayersResponse;
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

  //Delete comments
  Future<bool> deleteComment({@required int commentId}) async {
    try {
      var response = await RestClient.dio.delete(
        ApiURL.comment + "/${commentId}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return true; //todo verify
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

  //update Post
  Future<bool> updatePost(
      {@required NewPostRequest request, postId}) async {
    try {
      Map<String, dynamic> body = {"text": "${request?.text ?? ""}"};
      var response =
          await RestClient.dio.patch(ApiURL.post+"/$postId", data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        //todo parcse data
        CreatePostResponse prayersResponse = CreatePostResponse.fromJson(data);
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

  // report comment
  Future<bool> reportComment({@required int commentId}) async {
    try {
      var response = await RestClient.dio.post(
        ApiURL.comment + "/${commentId}/report",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return true; //todo verify
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
