import 'package:army120/features/challenges/bloc/challenge_bloc.dart';
import 'package:army120/features/challenges/bloc/challenge_state.dart';
import 'package:army120/features/challenges/bloc/chanllenge_events.dart';
import 'package:army120/features/challenges/data/model/category.dart';
import 'package:army120/features/challenges/data/model/start_challenge_request.dart';
import 'package:army120/features/challenges/ui/select_challenge/selectGroup.dart';
import 'package:army120/features/group/bloc/group_bloc.dart';
import 'package:army120/features/group/data/group_repository.dart';
import 'package:army120/features/group/data/model/group.dart';
import 'package:army120/features/group/ui/group_grid_view.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptChallenge extends StatefulWidget {
  final Categories category;

  AcceptChallenge({@required this.category});

  @override
  _AcceptChallengeState createState() => _AcceptChallengeState();
}

class _AcceptChallengeState extends State<AcceptChallenge> {
  ChallengeBloc _challengeBloc;

  @override
  get getHeader {
    return Container(
      height: getScreenSize(context: context).height * 0.2,
      width: getScreenSize(context: context).width,
      child: Stack(
        alignment: Alignment(0, 0),
        children: <Widget>[
          Positioned(
            top: 30,
            left: 20,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryColor,
                  size: 30,
                )),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              width: getScreenSize(context: context).width,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                          "${capitalize(value: widget?.category?.identifier ?? "")} Prayer Challenge",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22))),
                  Hero(
                    tag: "${widget?.category?.id}",
                    child: Image.asset(
                      getCategoryAsset(
                          identifier: widget?.category?.identifier),
                      height: 90,
                      width: 90,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _challengeBloc = BlocProvider.of<ChallengeBloc>(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
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
    ));
  }

  Widget get getPage {
    double height = getScreenSize(context: context).height;

    return Column(
      children: <Widget>[
        getHeader,
        Divider(
          height: 8,
          thickness: 4,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding:
                EdgeInsets.symmetric(horizontal: 24, vertical: height * 0.07),
            child: Column(
              children: <Widget>[
                getSpacer(height: height * 0.1),
                getCustomButton(
                    title: "Start Alone",
                    onTap: () {
                      startAlone();
                    }),
                getSpacer(height: height * 0.06),
                getCustomButton(
                    title: "Start with group",
                    onTap: () {
                      getGroup();
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getCustomButton({String title, onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          alignment: Alignment(0, 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryColor, width: 2)),
          child: Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
    );
  }

  startAlone() {
    print("added");
    _challengeBloc.add(StartChallenge(
        request: StartChallengeRequest(category: widget?.category.identifier)));
  }

  getGroup() async {
    Group group =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SelectGroupView();
    }));

    if (group != null) {
      startWithGroup(group?.id);
    }
  }

  startWithGroup(int groupId) {
    print("added");
    _challengeBloc.add(StartChallenge(
        request: StartChallengeRequest(
      category: widget?.category?.identifier,
      group: groupId,
    )));
  }
}
