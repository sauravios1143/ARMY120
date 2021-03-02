import 'package:army120/features/group/bloc/group_event.dart';
import 'package:army120/features/group/bloc/group_state.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupRepository groupRepository;

  GroupBloc({@required this.groupRepository});

  @override
  GroupState get initialState => GroupIdleState();

  @override
  Stream<GroupState> mapEventToState(GroupEvent event) async* {
    print("Event $event");

    // Create new Post
    if (event is FetchGroup) {
      //Fetch prayer listing
      yield FetchingGroupState(); //todo uncomment
      // yield GroupFetchSuccessState(groups: []);
// return ;
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield GroupErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await groupRepository.fetchGroups();
        print("got x ${x.toJson()}");
        yield GroupFetchSuccessState(groups: x?.data?.groups);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield GroupErrorState(message: e.toString());
      }
    }

    if (event is FetchGroupDetail) {
      //Fetch prayer listing
      yield FetchingGroupState(); //todo uncomment
      // yield GroupFetchSuccessState(groups: []);
// return ;
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield GroupErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await groupRepository.fetchGroupDetail(id: event?.groupId);
        print("got x ${x.toJson()}");
        yield FetchGroupDetailSuccess(groupDetial: x?.data);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield GroupErrorState(message: e.toString());
      }
    }

    if (event is CreateNewGroup) {
      yield GroupUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield GroupErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await groupRepository.createNewGroup(request: event?.request);

        yield CreateNewGroupSuccess(response: x);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield GroupErrorState(message: e.toString());
      }
    }

    if (event is EdiitOrAddMember) {
      yield GroupUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield GroupErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await groupRepository.addMember(
            request: event?.request, groupId: event?.request?.groupId);

        yield MemberAddedSuccessState(response: x);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield GroupErrorState(message: e.toString());
      }
    }

    if (event is DeleteGroup) {
      yield GroupUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield GroupErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await groupRepository.deleteGroup(groupId: event?.id);

        yield GroupDeletedSucces();
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield GroupErrorState(message: e.toString());
      }
    }

    if (event is RemoveMember) {
      if (event?.isCurrent ?? false) {
        yield GroupUpdatingState();
      }

      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield GroupErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await groupRepository.removeMember(
            id: event?.id, groupId: event?.groupId);

        yield MemberRemovedSuccess(wasCurrentUser: event?.isCurrent,groupDetail: x?.data);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield GroupErrorState(message: e.toString());
      }
    }

    if (event is FetchUserEvent) {
      yield FetchingUserState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield GroupErrorState(message: AppMessages.noInternet);
          return;
        }
        var x = await groupRepository.fetchUsers(searchBy: event.searchBy);

        yield FetchUserSuccessState(userList: x?.hits);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield GroupErrorState(message: e.toString());
      }
    }
  }
}
