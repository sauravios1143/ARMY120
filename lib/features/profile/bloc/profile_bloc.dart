import 'dart:convert';
import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/auth/data/model/user_detail_response.dart';
import 'package:army120/features/profile/bloc/profile_events.dart';
import 'package:army120/features/profile/bloc/profile_state.dart';
import 'package:army120/features/profile/data/model/update_profile_response.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({this.repository});

  @override
  ProfileState get initialState => ProfileInitialState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is UpdateUserDetail) {
      yield ProfileUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ProfileErrorState(message: AppMessages.noInternet);
          return;
        }

        UpdateProfileResponse response = await repository.updateUserDetail(
            request: event?.updateProfileRequest);
        yield UpdateSuccessState(updateProfileResponse: response);
      } catch (e) {
        print("Exception in login ${e}");
        yield ProfileErrorState(message: e.toString());
      }
    }
    //update push
    if (event is GetPushStatus) {
      yield ProfileUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ProfileErrorState(message: AppMessages.noInternet);
          return;
        }

        var response = await repository.getPushStatus();
        yield FetchPushStatus(
            data: response?.data
        );
      } catch (e) {
        print("Exception in login ${e}");
        yield ProfileErrorState(message: e.toString());
      }
    }
    //update push
    if (event is UpdatePush) {
      yield ProfileUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ProfileErrorState(message: AppMessages.noInternet);
          return;
        }

        var response = await repository.updatePush(request: event?.pushRequest);
        if (response == true) {
          yield UpdatePushSuccess();
        }
      } catch (e) {
        print("Exception in login ${e}");
        yield ProfileErrorState(message: e.toString());
      }
    }

/*
    if (event is UpdateProfilePicture) {
      yield ProfileUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ProfileErrorState(message: AppMessages.noInternet);
          return;
        }

        UpdateProfileResponse response =
            await repository.uploadProfilePicture(file: event?.file);
        yield UpdateSuccessState(updateProfileResponse: response);
      } catch (e) {
        print("Exception in login ${e}");
        yield ProfileErrorState(message: e.toString());
      }
    }
*/

    //get user Detail
    if (event is FetchUserDetail) {
      yield FetchingDetailState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ProfileErrorState(message: AppMessages.noInternet);
          return;
        }

        UserDetailResponse response = await repository.getUserDetail();
        yield FetchUserDetailSuccessState(userDetail: response?.data);
      } catch (e) {
        print("Exception in login ${e}");
        yield ProfileErrorState(message: e.toString());
      }
    } //get user Detail
    if (event is FetchOtherUserDetail) {
      yield FetchingDetailState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ProfileErrorState(message: AppMessages.noInternet);
          return;
        }

        UserDetailResponse response =
            await repository.getOtherUserDetail(userId: event?.userId);
        yield FetchUserDetailSuccessState(userDetail: response?.data);
      } catch (e) {
        print("Exception in login ${e}");
        yield ProfileErrorState(message: e.toString());
      }
    }

    //logout
    if (event is Logout) {
      yield ProfileUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ProfileErrorState(message: AppMessages.noInternet);
          return;
        }

        var response = await repository.logout(token: event?.token);
        yield LogoutSuccessState();
      } catch (e) {
        print("Exception in login ${e}");
        yield ProfileErrorState(message: e.toString());
      }
    }
  }
}
