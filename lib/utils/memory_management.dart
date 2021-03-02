import 'package:army120/utils/SharedPrefsKeys.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryManagement {
  static SharedPreferences prefs;

  static Future<bool> init() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  static void setAccessToken({@required String accessToken}) {
    prefs.setString(SharedPrefsKeys.ACCESS_TOKEN, accessToken);
  }

  static String getAccessToken() {
    return prefs.getString(SharedPrefsKeys.ACCESS_TOKEN);
  }

  
  static void setUserInfo({@required String userInfo}) {
    prefs.setString(SharedPrefsKeys.USER_INFO, userInfo);
  }
  static void setUserDetail({@required String userInfo}) {
    prefs.setString(SharedPrefsKeys.USER_DETAIL, userInfo);
  }

  static String getUserInfo() {
    return prefs.getString(SharedPrefsKeys.USER_INFO);
  }

  static String getUserDetail() {
    return prefs.getString(SharedPrefsKeys.USER_DETAIL);
  }

  static void setIsUserLoggedIn({@required bool isUserLoggedin}) {
    prefs.setBool(SharedPrefsKeys.IS_USER_LOGGED_IN, isUserLoggedin);
  }
  static void setIsSkipped({@required bool isUserLoggedin}) {
    prefs.setBool(SharedPrefsKeys.IS_SKIPPED, isUserLoggedin);
  }

  static bool getISSkipped() {
    return prefs.getBool(SharedPrefsKeys.IS_SKIPPED);
  }

  static bool getIsUserLoggedIn() {
    return prefs.getBool(SharedPrefsKeys.IS_USER_LOGGED_IN);
  } 

  static void setIsProfileCompleted({@required bool isProfileCompleted}) {
    prefs.setBool(SharedPrefsKeys.IS_PROFILE_COMPLETED, isProfileCompleted);
  }

  static bool getIsProfileCompleted() {
    return prefs.getBool(SharedPrefsKeys.IS_PROFILE_COMPLETED);
  }





  //clear all values from shared preferences
  static void clearMemory() {
    prefs.clear();
  }
}
