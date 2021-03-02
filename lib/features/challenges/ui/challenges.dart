import 'package:army120/features/challenges/bloc/challenge_bloc.dart';
import 'package:army120/features/challenges/bloc/challenge_state.dart';
import 'package:army120/features/challenges/bloc/chanllenge_events.dart';
import 'package:army120/features/challenges/data/challenge_repository.dart';
import 'package:army120/features/challenges/data/model/active_challenge_esponse.dart';
import 'package:army120/features/challenges/ui//select_challenge/select_challege_screen.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/features/profile/ui/notification_buttons.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengesScreen extends StatefulWidget {
  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  //props
  bool _gotData = false;
  ChallengeBloc _challengeBloc;
  ActiveChallenge _activeChallenge;

  //getters
  get getNotificatinItems {
    return BlocProvider(
        create: (BuildContext context) =>
            ProfileBloc(repository: ProfileRepository()),
        child: NotificationButtons());
  }

  get getPage {
    return BlocBuilder<ChallengeBloc, ChallengeState>(
        builder: (context, state) {
      return Builder(
        builder: (context) {
          Widget _child;
          if (state is FetchActiveChallengeSuccessState) {
            setData(state);
            _child = getChalleneDetail;
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
            _child = getChalleneDetail;
          }

          return _child;
        },
      );
    });
  }

  get getBottomSheet {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//        color: Colors.yellow,
      width: double.infinity,
      child: Wrap(
         // mainAxisSize: MainAxisSize.min,
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,

        children: [
          getAppThemedFilledButton(
              title: "Explore Challenges",
              onpress: () async{
               var x= await  Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlocProvider(
                    create: (context) =>
                        ChallengeBloc(repository: ChallengeRepository()),
                    child: SelectChallenge(
                      currentCateogry: _activeChallenge?.currentPrayerChallenge,
                    ),
                  );
                }));

               if(x==1){
                 fetchActiveChallenge();
               }
              }),
          getNotificatinItems,
        ],
      ),
    );
  }

  Widget get getPrayerTile {
    return Container(
      alignment: Alignment.center,
      child: Text(
        _activeChallenge?.dailyPrayer,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  get getChanllengeList {
    return Align(
      alignment: Alignment?.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: Text(
            _activeChallenge.currentPrayerChallenge==null?"No challenge joined currently":
            "On ${_activeChallenge?.currentPrayerChallenge} challenge",
          style: TextStyle(
            color: Colors.grey,fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget get getChalleneDetail {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: getPrayerTile),
          getChanllengeList,
          // getSpacer(
          //     height:
          // ),
          getBottomSheet],
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
    return Scaffold(
        appBar: getAppThemedAppBar(context, titleText: "Daily Challenges"),
        body: getPage
        // bottomSheet: getBottomSheet,
        );
  }

  fetchActiveChallenge() {
    _challengeBloc.add(FetchActiveChallengeEvent());
  }

  setData(FetchActiveChallengeSuccessState state) {
    _activeChallenge= state?.activeChallege;
  }
}
