import 'package:army120/features/auth/data/model/profile_ficture.dart';
import 'package:army120/features/group/data/model/create_group_response.dart';
import 'package:army120/features/group/data/model/group_detail_response.dart';
import 'package:army120/features/group/data/model/new_group_request.dart';
import 'package:army120/features/home/data/model/patron_listing_response.dart';
import 'package:army120/features/group/data/model/prayer_response.dart';
import 'package:army120/features/group/data/model/user_listing_response.dart';
import 'package:army120/features/profile/data/model/media_signature_response.dart';
import 'package:army120/network/apiError.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/network/fileUpload.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GroupRepository {
  FileUpload _uploadMethod = new FileUpload();

  //fetch Group Listing
  Future<GroupListResponse> fetchGroups() async {
    try {
      var response = await RestClient.dio.get(ApiURL.getGroups);
      if (response.statusCode == 200) {
        var data = response.data;
        GroupListResponse prayersResponse = GroupListResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    }
  }

  //fetch Group Listing
  Future<GroupDetailResponse> fetchGroupDetail({id}) async {
    try {
      var response = await RestClient.dio.get(ApiURL.addMembers + "/$id");
      if (response.statusCode == 200) {
        var data = response.data;
        GroupDetailResponse prayersResponse = GroupDetailResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    }
  }

  //fetch Prayer Detial
  Future<CreateGroupResponse> createNewGroup(
      {@required NewGroupRequest request}) async {
    try {
      if (request?.imageFile != null) {
        MediaSignatureResponse mediaSignatureResponse =
            await _uploadMethod.mediaSignature(file: request?.imageFile);

        if (mediaSignatureResponse != null) {
          ProfilePicture uploadReponse = await _uploadMethod.uploadFile(
              file: request?.imageFile,
              mediaSignatureResponse: mediaSignatureResponse);
          request.icon = uploadReponse;
        } else {
          throw ApiException(message: "Unable to upload Icon ");
        }
      }

      var response = await RestClient.dio
          .post(ApiURL.createNewGroup, data: request.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        CreateGroupResponse prayersResponse =
            CreateGroupResponse.fromJson(data);

        //add members
        var addMemberResponse = await addMember(
            request: request, groupId: prayersResponse?.data?.group?.id);

        //tod check for success
        return prayersResponse;
      } else {
        throw Exception();
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    }
  }

  //fetch Prayer Detial
  Future<CreateGroupResponse> addMember(
      {@required NewGroupRequest request, groupId}) async {
    try {
      Map<String, dynamic> body = {"members": request.members};

      var response = await RestClient.dio
          .post(ApiURL.addMembers + "/${groupId}/members", data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Respone--> ${response.data}");
        var data = response.data;
        CreateGroupResponse prayersResponse =
            CreateGroupResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw Exception();
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    }
  }

  //frlryr Detial
  Future<bool> deleteGroup({@required groupId}) async {
    try {
      var response =
          await RestClient.dio.delete(ApiURL.addMembers + "/${groupId}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception();
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    }
  }

  //Remove Member
  Future<GroupDetailResponse> removeMember({@required id,groupId}) async {
    try {

      var body ={"members":[id]};
      var response = await RestClient.dio
          .delete(ApiURL.addMembers + "/${groupId}/members", data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        GroupDetailResponse prayersResponse = GroupDetailResponse.fromJson(response?.data);
        return prayersResponse;
      } else {
        throw Exception();
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    }
  }

  //fetch User Listing
  Future<UserListingResponse> fetchUsers({String searchBy}) async {
    try {
      var response = await RestClient.dio
          .get(ApiURL.getUsers + "?q=${searchBy ?? " "}"); /*${searchBy??""}*/
      if (response.statusCode == 200) {
        var data = response.data;
        UserListingResponse prayersResponse =
            UserListingResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");
      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message: AppMessages?.commonError);
      }
    }
  }
}
