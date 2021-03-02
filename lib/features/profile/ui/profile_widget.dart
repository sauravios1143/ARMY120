import 'package:army120/features/auth/data/model/user_detail.dart';
import 'package:army120/features/profile/bloc/profile_events.dart';
import 'package:army120/features/profile/bloc/profile_state.dart';
import 'package:army120/features/profile/data/model/push_request.dart';
import 'package:army120/features/profile/data/model/update_profile_request.dart';
import 'package:army120/utils/Constants/next_step.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/ProgressIndicator.dart';
import 'package:army120/utils/reusableWidgets/efit_profile_dialogs/customDialog.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  // props

  String _currentStatus;

  num filledValue = 0;
  bool gotData = false;
  ProfileBloc _profileBloc;
  UserDetail userDetail;
  bool hide = false;

  // Returns progress bar
  get _getProgressBar {
    return new Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: new ProgressIndicatorBar(
          filledValue: filledValue,
        ));
  }

  //get profile card
  get getProfileCard {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Profile Completed   ${filledValue?.toInt()}%",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(child: _getProgressBar),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    getButtonText(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey),
                  )),
                  Material(
                    color: AppColors.primaryColor,
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: onNextButtonPress,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // EditProfileCards(step: _currentStatus)
            ],
          ),
        ),
      ),
    );
  }

  get getCardView {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return Builder(
        builder: (context) {
          Widget _child;
          if (state is FetchUserDetailSuccessState) {
            setUserData(state?.userDetail);

            _child = getProfileCard;
          } else if (state is FetchingDetailState ||
              state is ProfileInitialState) {
            _child = LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor:
                  new AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            );
          } else if (state is ProfileErrorState && !gotData) {
            _child = getNoDataView(
                msg: state?.message,
                onRetry: () {
                  fetchDetail();
                });
          } else {
            _child = getProfileCard;
          }

          return _child;
        },
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hide = LoggedInUser?.getUserDetail?.profileCompletion?.completion == 100;
  }

  //State methods
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!gotData) {
      _profileBloc = BlocProvider.of<ProfileBloc>(context);
      if (!hide) {
        fetchDetail();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
        offstage:  false,
        child: Stack(
          children: [
            getCardView,
            BlocListener<ProfileBloc, ProfileState>(
                child: Container(
                  height: 0,
                  width: 0,
                ),
                listener: (context, state) async {
                  if (state is ProfileErrorState) {
                    showAlert(
                        context: context,
                        titleText: "Error",
                        message: state?.message ?? "",
                        actionCallbacks: {"Ok": () {}});
                  }
                  if (state is UpdateSuccessState) {
                    onUpdateSuccess(state);
                  }
                  if (state is UpdatePushSuccess) {
                    onPushUpdateSuccess();
                  }
                })
          ],
        ));
//    getProfileCard;
  }

  //get button text
  String getButtonText() {
    String txt = "";
    switch (_currentStatus) {
      case NextStep.gender:
        txt = "Next: Add your gender";
        break;
      case NextStep.picture:
        txt = "Next: Add your picture";
        break;
      case NextStep.dob:
        txt = "Next: Add your Age";
        break;
      case NextStep.phone:
        txt = "Next: Add your Phone";
        break;
      case NextStep.about:
        txt = "Next: What's your story";
        break;
      case NextStep.complete:
        txt = "Next: You've earned a Badge!";
        break;
      case NextStep.push:
        txt = "Next: Push";
        break;
      case NextStep.complete:
        break;
    }
    return txt;
  }

  //set filled value
/*  setProgress() {
    switch (_currentStatus) {
      case ProfileStatus.login:
        filledValue = 20;
        break;
      case ProfileStatus.gender:
        filledValue = 40;
        break;
      case ProfileStatus.image:
        filledValue = 60;
        break;
      case ProfileStatus.age:
        filledValue = 80;
        break;
      case ProfileStatus.about:
        filledValue = 100;
        break;
      case ProfileStatus.Completed:
        filledValue = 100;
        break;
    }
  }*/

  //  fetch detail
  fetchDetail() {
    _profileBloc.add(FetchUserDetail());
  }

  //set urser Data (){
  setUserData(UserDetail userDetail) {
    gotData = true;
    userDetail = userDetail;
    filledValue = userDetail?.profileCompletion?.completion;
    hide = filledValue == 100;
    print("--fileed=${filledValue}");
    _currentStatus = userDetail?.profileCompletion?.nextStep;
    if(filledValue==100){
      Navigator.pop(context);
    }


  }

  //update profile
  updateProfile(UpdateProfileRequest request) {
    if (request.currentStep == NextStep.push) {
      updatePush(request);
    } else {
      _profileBloc.add(UpdateUserDetail(updateProfileRequest: request));
    }
  }

  //update profile
  updatePush(UpdateProfileRequest request) {
    _profileBloc.add(UpdatePush(
        pushRequest: PushRequest(
            pushAlarm: true, superAlarm: false, token: request.token)));
  }

  onUpdateSuccess(UpdateSuccessState state) {
    setUserData(state?.updateProfileResponse?.data);
  }

  onPushUpdateSuccess() async {
    // gotData=false;
    await fetchDetail();
    setState(() {});
    // setUserData(state?.updateProfileResponse?.data);
  }

  //profile actions
  onNextButtonPress() async {
    if (hide == true) {
      setState(() {});
      return;
    }
    var x = await showDialog(
        context: context,
        builder: (context) {
          return EditProfileCards(step: _currentStatus);
        });

    if (x != null) {
      updateProfile(x);
    }
  }
}
