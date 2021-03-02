import 'package:army120/features/auth/data/model/profile_ficture.dart';

class User {
  String token;
  String userEmail;
  int userId;
  int id;
  String username;
  String firstName;
  String lastName;
  bool onboarded;
  String dailyPrayer;
  String prayerChallenge;
  String userKind;
  ProfilePicture  profilePicture;


  User(
      {this.token,
        this.userEmail,
        this.id,
        this.userId,
        this.username,
        this.firstName,
        this.lastName,
        this.onboarded,
        this.dailyPrayer,
        this.prayerChallenge,this.profilePicture,
        this.userKind});

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userEmail = json['userEmail'];
    userId = json['userId'];
    id = json['id'];
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    onboarded = json['onboarded'];
    dailyPrayer = json['dailyPrayer'];
    prayerChallenge = json['prayerChallenge'];
    userKind = json['userKind'];
    profilePicture = json['profilePicture'] != null
        ? new ProfilePicture.fromJson(json['profilePicture'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['userEmail'] = this.userEmail;
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['username'] = this.username;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['onboarded'] = this.onboarded;
    data['dailyPrayer'] = this.dailyPrayer;
    data['prayerChallenge'] = this.prayerChallenge;
    data['userKind'] = this.userKind;
    if (this.profilePicture != null) {
      data['profilePicture'] = this.profilePicture.toJson();
    }
    return data;
  }
}


