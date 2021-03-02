import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/bloc/profile_events.dart';
import 'package:army120/features/profile/bloc/profile_state.dart';
import 'package:army120/features/profile/data/model/notificaton_model.dart';
import 'package:army120/features/profile/data/model/push_request.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/Constants/notifcation_type.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum notificationType { active, silent, ring }

class NotificationButtons extends StatefulWidget {
  @override
  _NotificationButtonsState createState() => _NotificationButtonsState();
}

class _NotificationButtonsState extends State<NotificationButtons> {
  //pros
  ProfileBloc _profileBloc;

  notificationType selectedType;

  GlobalKey toolTipKey = new GlobalKey();

  //getters
  Widget get getNotificationIcons {
    return Row(
      mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, children: [
      getNotificationItem(type: notificationType.silent),
      getNotificationItem(type: notificationType.active),
      getNotificationItem(type: notificationType.ring),
    ]);
  }

  getNotificationItem({notificationType type}) {
    bool isActive = selectedType == type;
    return InkWell(
        onTap: () {
          onNotificationTypeChange(type);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            getNotificationAsset(type),
            height: 30,
            width: 30,
            color: isActive ? AppColors.primaryColor : Colors.grey,
          ),
        ));
  }

  //State methods
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setCurrentStatus(LoggedInUser?.getUserDetail?.sendAlarm);

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    getPushStatus();
  }

  Widget get getNotificatonButtons{
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context,state){
        if(state is FetchPushStatus){
          setPushData(state?.data);
        }
      },
      child: Tooltip(
        message: getMessage(),
        preferBelow: false,
        key: toolTipKey,
        showDuration: Duration(seconds: 2),
        child: getNotificationIcons,),
    );
  }
  @override
  Widget build(BuildContext context) {
    return getNotificatonButtons;
  }

  getNotificationAsset(notificationType type) {
    String assetItem = "";
    switch (type) {
      case notificationType.active:
        assetItem = AssetStrings.notification;
        break;
      case notificationType.silent:
        assetItem = AssetStrings.silentNotification;

        break;
      case notificationType.ring:
        assetItem = AssetStrings.doubleNotification;
        break;
    }
    return assetItem;
  }

  onNotificationTypeChange(notificationType type) {



    if(isLoggedIn()){
      selectedType = type;
      setState(() {});
      showToolTip();

      updatePush(type);
    }else{
      showLoginBottomSheet(context);
    }

  }

  updatePush(notificationType type) async {

    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String token = await _firebaseMessaging.getToken() ?? "";
    _profileBloc.add(UpdatePush(
        pushRequest: PushRequest(
            pushAlarm: (type == notificationType.silent) ? false : true,
            superAlarm: (type == notificationType.ring) ? true : false,
            token: token)));
  }

/*  setCurrentStatus(bool value){
    selectedType= (value==true)?notificationType.active:notificationType.silent;
  }*/


  getPushStatus(){
    _profileBloc.add(GetPushStatus());
  }
  setPushData(PushData pushData ) {
    bool superA=pushData?.superAlarm??false;
    bool normalA= pushData?.pushAlarm??false;
    selectedType = (normalA)?(superA?notificationType.ring:notificationType.active):notificationType.silent;
    print("data set ${selectedType}");
    setState(() {

    });
  }
  String getMessage(){
    switch(selectedType){
      case notificationType.active:
       return "Everyday at 1:20pm";
        break;
      case notificationType.silent:
       return "No notifications";
        break;
      case notificationType.ring:
       return "1:20pm across US timezone";
        break;
      default:return "";
    }
  }
  showToolTip()async{
    _showToast(context);
    /*await Future.delayed(Duration(milliseconds: 500));
    final dynamic tooltip = toolTipKey.currentState;
    tooltip.ensureTooltipVisible();*/

  }
  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        shape: StadiumBorder(),
        elevation: 4.0,
        duration: Duration(milliseconds: 500),
        backgroundColor: Colors.black.withOpacity(0.7),
        content:  Text("${getMessage()}"),
      ),
    );

  }


}
