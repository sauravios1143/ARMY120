import 'dart:convert';

import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/auth/data/model/user_detail.dart';
import 'package:army120/features/dashboard/Dashboard.dart';
import 'package:army120/features/auth/bloc/auth_bloc.dart';
import 'package:army120/features/auth/data/auth_repository.dart';
import 'package:army120/features/auth/ui/login_screen.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/memory_management.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Image.asset(AssetStrings.logo)),
    );
  }

  //Check if User is already logged in
  checkAuthentication() async {
    await MemoryManagement.init();
    await Firebase.initializeApp();
    try {
      RestClient().create();
    } catch (e, st) {
      print("e $e, \n$st");
    }
    await Future.delayed(Duration(seconds: 2));
    String accessToken = MemoryManagement?.getAccessToken() ?? "";
    if (accessToken.isNotEmpty) {
      await loadUserData();

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Dashboard();
      }), (Route<dynamic> route) => false);
    }
    else {
      if(isSkipped()){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return Dashboard();
            }), (Route<dynamic> route) => false);
        return ;
      }

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return BlocProvider(
          create: (context) => AuthBloc(repository: AuthRepository()),
          child: LoginScreen(),
        );
      }), (Route<dynamic> route) => false);
    }
  }

  //Load User data from memory
  loadUserData(){
    String _data = MemoryManagement.getUserInfo()??"";
    String _detail = MemoryManagement.getUserDetail();

    LoggedInUser.setUser =  User.fromJson(jsonDecode(_data));

    if(_detail!=null){
      LoggedInUser.setUserDetail = UserDetail?.fromJson(jsonDecode(_detail??""));

    }

  }
}
