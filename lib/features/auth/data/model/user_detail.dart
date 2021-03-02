import 'package:army120/features/auth/data/model/badge.dart';
import 'package:army120/features/auth/data/model/profile_ficture.dart';

class UserDetail {
  int id;
  String firstName;
  String lastName;
  String username;
  String phone;
  String email;
  bool emailVerified;
  String facebookId;
  String dateOfBirth;
  String gender;
  String about;
  String location;
  ProfilePicture profilePicture;
  bool selfUploadedProfilePicture;
  String kind;
  String joinDate;
  bool onboarded;
//  List<Null> blockedUsers;
  bool sendAlarm;
  String stripeCustomerId;
  ProfileCompletion profileCompletion;
  List<Badges> badges;



//  ProfilePicture  profilePicture;

  UserDetail(
      {this.id,
        this.firstName,
        this.lastName,
        this.username,
        this.phone,
        this.email,
        this.emailVerified,
        this.facebookId,
        this.dateOfBirth,
        this.gender,
        this.about,
        this.location,
        this.profilePicture,
        this.selfUploadedProfilePicture,
        this.kind,
        this.joinDate,
        this.onboarded,
//        this.blockedUsers,
        this.sendAlarm,
        this.stripeCustomerId,
        this.profileCompletion});

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    phone = json['phone'];
    email = json['email'];
    emailVerified = json['emailVerified'];
    facebookId = json['facebookId'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    about = json['about'];
    location = json['location'];
    profilePicture = json['profilePicture'] != null
        ? new ProfilePicture.fromJson(json['profilePicture'])
        : null;
    selfUploadedProfilePicture = json['selfUploadedProfilePicture'];
    kind = json['kind'];
    joinDate = json['joinDate'];
    onboarded = json['onboarded'];
//    if (json['blockedUsers'] != null) {
//      blockedUsers = new List<Null>();
//      json['blockedUsers'].forEach((v) {
//        blockedUsers.add(new Null.fromJson(v));
//      });
//    }
    sendAlarm = json['sendAlarm'];
    stripeCustomerId = json['stripe_customer_id'];
    profileCompletion = json['profileCompletion'] != null
        ? new ProfileCompletion.fromJson(json['profileCompletion'])
        : null;
    if (json['badges'] != null) {
      badges = new List<Badges>();
      json['badges'].forEach((v) {
        badges.add(new Badges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['emailVerified'] = this.emailVerified;
    data['facebookId'] = this.facebookId;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['about'] = this.about;
    data['location'] = this.location;
    if (this.profilePicture != null) {
      data['profilePicture'] = this.profilePicture.toJson();
    }
    data['selfUploadedProfilePicture'] = this.selfUploadedProfilePicture;
    data['kind'] = this.kind;
    data['joinDate'] = this.joinDate;
    data['onboarded'] = this.onboarded;
//    if (this.blockedUsers != null) {
//      data['blockedUsers'] = this.blockedUsers.map((v) => v.toJson()).toList();
//    }
    data['sendAlarm'] = this.sendAlarm;
    data['stripe_customer_id'] = this.stripeCustomerId;
    if (this.profileCompletion != null) {
      data['profileCompletion'] = this.profileCompletion.toJson();
    } if (this.profileCompletion != null) {
      data['profileCompletion'] = this.profileCompletion.toJson();
    }
    if (this.badges != null) {
      data['badges'] = this.badges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileCompletion {
  int completion;
  String nextStep;

  ProfileCompletion({this.completion, this.nextStep});

  ProfileCompletion.fromJson(Map<String, dynamic> json) {
    completion = json['completion'];
    nextStep = json['nextStep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completion'] = this.completion;
    data['nextStep'] = this.nextStep;
    return data;
  }
}