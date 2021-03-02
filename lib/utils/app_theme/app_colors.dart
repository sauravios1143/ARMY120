import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

//  static Color hexToColor(String code) {
//    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
//  }

  static const Color primaryColor =appRed;

//  static const  Color appRed =Color.fromRGBO(252, 31, 46, 1);
//  static const  Color appRed =Color.fromRGBO(255, 0, 50, 1);

//  static const Color lightRed =Color.fromRGBO(255, 147, 147, 1);
//  static const Color ultraLightBGColor  =Color.fromRGBO(255, 238, 238, 0.5);
//  static const Color lightBGColor  =Color.fromRGBO(255, 245, 245, 1);
//  static const Color modrate  =Color.fromRGBO(255, 238, 238, 1);

  static const Color   appRed = const Color(0xFFFF1923); //priary
  static const Color   appMediumRed = const Color(0xFFF86671); //priary
  static const Color   appDarkRed = const Color(0xFFBA2F2F); //priary
  static const Color   appLightRed = const Color(0xFFEE8E9E); //priary
  static const Color   ultraLightBGColor = const Color(0xFFFFEEEE); //
  static const Color   lightBGColor = const Color(0xFFFFB8B8); //
  static const Color   appGrey = const Color(0xFFC4C4C4); //
  static const Color   appLightGrey = const Color(0xFFF1F1F1); //
  static const Color   appDarkGrey= const Color(0xFF828282); //
  static const Color   appBlack= const Color(0xFF100606); //
  static const Color   popUpBGColor= const Color(0xff7e0000); //


  //background colors
//  static const  Color appBlue = Color.fromRGBO(45,98 ,143,1);// kindd of green
//  static const  Color appYellow =Colors.yellow; //Color.fromRGBO(163,181 ,118,1);// green
  static const  Color kGrey= Colors.grey;
  static const  Color appBlue= Colors.blue;


  static const MaterialColor buttonTextColor = const MaterialColor(
      0xFFFF1923,
  const <int, Color>{
  50: primaryColor,
  100: primaryColor,
  200: primaryColor,
  300: primaryColor,
  400:primaryColor,
  500:primaryColor,
  600:primaryColor,
  700:primaryColor,
  800:primaryColor,
  900:primaryColor,
  });


}
