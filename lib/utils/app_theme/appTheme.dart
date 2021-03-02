import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {

  //Font Families
  static final String fontFamilyRoboto="roboto";
  static final String fontFamilyGotham="gotham";
  static final String fontFamilyOpenSans="OpenSans";
  static final String fontFamilyHolyFat="HolyFat";


  //app Theme
  static var appTheme = ThemeData(
//    fontFamily: fontFamilyRoboto,
//    fontFamily: fontFamilyGotham,
//    fontFamily: fontFamilyOpenSans,
//    primarySwatch: MaterialColor(0xffBA0C2F, color),
  primaryColor: AppColors.primaryColor,
//    accentColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 4.0,
    iconTheme: IconThemeData(color: AppColors.primaryColor),
  ),

  );


  static TextStyle smallFontStyle = TextStyle(
    fontSize: 12,
  );static TextStyle smallBoldFontStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold
  );

  static TextStyle titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold
  );
  static TextStyle currencyStyle = TextStyle(
    fontFamily: fontFamilyRoboto,
    fontSize: 16,
    fontWeight: FontWeight.bold
  );
  static TextStyle drawerTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
      color: AppColors.primaryColor,
  );
  static TextStyle optionStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,

  );


}
