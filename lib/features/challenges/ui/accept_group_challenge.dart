import 'package:army120/features/challenges/bloc/challenge_bloc.dart';
import 'package:army120/features/challenges/bloc/challenge_state.dart';
import 'package:army120/features/challenges/bloc/chanllenge_events.dart';
import 'package:army120/features/challenges/data/challenge_repository.dart';
import 'package:army120/features/challenges/data/model/active_challenge_esponse.dart';
import 'package:army120/features/challenges/data/model/group_challenge_request_response.dart';
import 'package:army120/features/challenges/data/model/start_challenge_request.dart';
import 'package:army120/features/challenges/ui//select_challenge/select_challege_screen.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/features/profile/ui/notification_buttons.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptGroupChallenge extends StatefulWidget {
  final String identifier;

  AcceptGroupChallenge({this.identifier});

  @override
  _AcceptGroupChallengeState createState() => _AcceptGroupChallengeState();
}

class _AcceptGroupChallengeState extends State<AcceptGroupChallenge> {
  //props
  bool _gotData = false;
  ChallengeBloc _challengeBloc;
  RequestData _activeChallenge;

  //getters
  get getNotificatinItems {
    return BlocProvider(
        create: (BuildContext context) =>
            ProfileBloc(repository: ProfileRepository()),
        child: NotificationButtons());
  }

  Widget get getPage {
    return BlocBuilder<ChallengeBloc, ChallengeState>(
        builder: (context, state) {
      return Builder(
        builder: (context) {
          Widget _child;
          if (state is FetchGroupChallengeRequestSuccess) {
            setData(state);
            _child = getRequestDetail;
          } else if (state is FetchingChallengeState ||
              state is ChallengeIdleState) {
            _child = CustomLoader();
          } else if (state is ChallengeErrorState && !_gotData) {
            _child = getNoDataView(
                msg: state?.message,
                onRetry: () {
                  fetchActiveChallenge();
                });
          } else {
            _child = getRequestDetail;
          }

          return _child;
        },
      );
    });
  }

  get getBottomSheet {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
            child: getButton(
                color: AppColors.appDarkRed,
                onTap: () {
                  Navigator.pop(context);
                },
                text: "Not Now")),
        getSpacer(width: 8),
        Expanded(
            child: getButton(color: Colors.blue, onTap: () {
              startAlone();
            }, text: "Join")),
      ]),
    );
  }

  Widget get getPrayerTile {
    return Container(
      alignment: Alignment.center,
      child: Text(
        _activeChallenge?.category?.description,
        textAlign: TextAlign.center,
        style: TextStyle(),
      ),
    );
  }

  Widget get getHeader {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "Join ${_activeChallenge?.category?.identifier} challenge",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
    );
  }

/*
  get getChanllengeList {
    return Text(
      _activeChallenge.currentPrayerChallenge==null?"No challenge joined currently":
      "On ${_activeChallenge?.currentPrayerChallenge} challenge",
      style: TextStyle(
          color: Colors.grey,fontWeight: FontWeight.bold
      ),
      textAlign: TextAlign.center,
    );
  }*/

  Widget get getRequestDetail {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10, bottom: 70),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  getHeader,
                  getSpacer(height: 16),
                  getPrayerTile,
                ],
              ),
            ),
          ),
          getBottomSheet
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gotData) {
      _challengeBloc = BlocProvider.of<ChallengeBloc>(context);
      fetchActiveChallenge();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(
      children: [
        getPage,
        BlocBuilder<ChallengeBloc, ChallengeState>(
          builder: (context, state) {
            return Offstage(
              offstage: !(state is ChallengeUpdatingState),
              child: CustomLoader(isTransparent: false),
            );
          },
        ),
        BlocListener<ChallengeBloc, ChallengeState>(
            child: Container(
              height: 0,
              width: 0,
            ),
            listener: (context, state) async {
              if (state is ChallengeErrorState) {
                showAlert(
                    context: context,
                    titleText: "Error",
                    message: state?.message ?? "",
                    actionCallbacks: {"Ok": () {}});
              }

              if (state is StartChallengeSuccessState) {
                showAlert(
                    context: context,
                    titleText: "Success",
                    message: "Challenge started Successfully",
                    actionCallbacks: {
                      "Ok": () {
                        Navigator.pop(context,1);
                      }
                    });
              }
            })
      ],
    ),
        // bottomSheet: getBottomSheet,
        );
  }

  fetchActiveChallenge() {
    _challengeBloc
        .add(FetchGroupChallengeRequest(identifier: widget?.identifier));
  }

  setData(FetchGroupChallengeRequestSuccess state) {
    _activeChallenge = state?.groupRequest;
  }
  startAlone() {
    print("added");
    _challengeBloc.add(StartChallenge(
        request: StartChallengeRequest(category: widget?.identifier)));
  }
}
