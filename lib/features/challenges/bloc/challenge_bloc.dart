import 'package:army120/features/challenges/bloc/challenge_state.dart';
import 'package:army120/features/challenges/bloc/chanllenge_events.dart';
import 'package:army120/features/challenges/data/challenge_repository.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository repository;

  ChallengeBloc({this.repository});

  @override
  ChallengeState get initialState => ChallengeIdleState();

  @override
  Stream<ChallengeState> mapEventToState(ChallengeEvent event) async* {
    //fetch challenges
    if (event is FetchChallengesEvent) {
      yield FetchingChallengeState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ChallengeErrorState(message: AppMessages.noInternet);
          return;
        }

        var response = await repository.fetchChallenges();
        yield FetchChallengeSuccessState(
            categoryList: response?.data?.categories); //todo add data ;
      } catch (e) {
        print("Exception in login ${e}");
        yield ChallengeErrorState(message: e.toString());
      }
    }
    //fetch active challenge
    if (event is FetchActiveChallengeEvent) {
      yield FetchingChallengeState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ChallengeErrorState(message: AppMessages.noInternet);
          return;
        }

        var response = await repository.fetchActiveChallenge();
        yield FetchActiveChallengeSuccessState(
            activeChallege: response?.data); //todo add data ;
      } catch (e) {
        print("Exception in login ${e}");
        yield ChallengeErrorState(message: e.toString());
      }
    }
    //create custom challenge
    if (event is CreateCustomChallenge) {
      yield FetchingChallengeState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ChallengeErrorState(message: AppMessages.noInternet);
          return;
        }
  //todo
        var response = await repository.fetchActiveChallenge();
        yield FetchActiveChallengeSuccessState(
            activeChallege: response?.data); //todo add data ;
      } catch (e) {
        print("Exception in login ${e}");
        yield ChallengeErrorState(message: e.toString());
      }
    }
    //fetch group request
    if (event is FetchGroupChallengeRequest) {
      yield FetchingChallengeState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ChallengeErrorState(message: AppMessages.noInternet);
          return;
        }

        var response = await repository.fetchGroupChallengeRequest(identifier: event?.identifier);
        yield FetchGroupChallengeRequestSuccess(
            groupRequest:response?.data);
      } catch (e) {
        print("Exception in login ${e}");
        yield ChallengeErrorState(message: e.toString());
      }
    }

    //start challenge
    if (event is StartChallenge) {
      print("start ");
      yield ChallengeUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield ChallengeErrorState(message: AppMessages.noInternet);
          return;
        }
        var response = await repository.startChallenge(request: event?.request);
        yield StartChallengeSuccessState();
      } catch (e) {
        print("Exception in login ${e}");
        yield ChallengeErrorState(message: e.toString());
      }
    }
  }
}
