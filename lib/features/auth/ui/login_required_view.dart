import 'package:army120/features/auth/bloc/auth_bloc.dart';
import 'package:army120/features/auth/data/auth_repository.dart';
import 'package:army120/features/auth/ui/login_screen.dart';
import 'package:army120/features/auth/ui/signup_screen.dart';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginRequiredView extends StatefulWidget {

  @override
  _LoginRequiredViewState createState() => _LoginRequiredViewState();
}

class _LoginRequiredViewState extends State<LoginRequiredView> {
  //props

  //getters

  Widget get getPage {
    return getRequestDetail;
  }
  get getBottomSheet {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
            child: getButton(
                color: AppColors.appDarkRed,
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(
                      builder: (context){
                        return BlocProvider(
                          create: (context)=>AuthBloc(repository: AuthRepository()),
                          child: LoginScreen(),
                        );
                      }
                  ));
                },
                text: "Login")),
        getSpacer(width: 8),
        Expanded(
            child: getButton(color: Colors.blue, onTap: () {
              Navigator.push(context,MaterialPageRoute(
                  builder: (context){
                    return BlocProvider(
                      create: (context)=>AuthBloc(repository: AuthRepository()),
                      child: SignupScreen(
                        isDirect: true,
                      ),
                    );
                  }
              ));

            }, text: "Sign Up")),
      ]),
    );
  }

  Widget get getPrayerTile {
    return Container(
      alignment: Alignment.center,
      child: Text(
       "Some feature require user Loin. Please login or sign up to use more exciting features of 120 army.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16
        ),
      ),
    );
  }

  Widget get getHeader {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "Login/Signup to continue",
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
    double height= getScreenSize(context: context).height;
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
                      icon: Icon(Icons.clear,size: 30,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  getSpacer(height: height*0.04),

                  getHeader,
                  getSpacer(height: height*0.04),
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
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(
      children: [
        getPage,
      ],
    ),
      // bottomSheet: getBottomSheet,
    );
  }




}
