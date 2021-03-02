import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/auth/data/model/user_detail.dart';

class LoggedInUser {
  static User user;
  static UserDetail userDetail;
  static LoggedInUser _loggedInUser;

  LoggedInUser._privateConstructor(); //privateConstructor

  factory LoggedInUser() {
    //factory Constructor
    if (_loggedInUser == null) {
      _loggedInUser = LoggedInUser._privateConstructor();
      return _loggedInUser;
    }
    return _loggedInUser;
  }

  static User get getUser => user;
  static UserDetail  get getUserDetail => userDetail;

  static set setUser(User x) {
    user = x;
  }

  static set setUserDetail(UserDetail x) {
    userDetail = x;
  }
}
//eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJlbWFpbCI6ImRldjFAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiRGV2In0.KvpweuDuuMH01tpHhFaPIUpOOQA-EklEKHepVOr4HEEb53CEEp1WTgBScLY7wBmkKRnwjw4S_ICH-i89VxwJjXoR5cdHg_XUei1LclkDoG1VbS9UoLSz4Gkk6upRvmpKskbCfGU8aNyOnBiFSNKDddwcWCU2FmuBOBpN-w1TLx0jXV8_6XGrT7Bq8wnTJGBR7XQ7uIjE9cYmhUZoRlEND-BTOyE0WOjHZUukj9lMwFDHWgFpGLE9l4zIwZFFDXqTCLC0N8tVaCqeIoyhgO4ztAnfAhyMxNxAgJ1nby7pHSbIwIitqhW-dfvo5A-X9ruxuYIlnms3avYT3zGELlwVcg
