class ActivePrayerChallenge {
  String message;
  ActiveChallenge data;

  ActivePrayerChallenge({this.message, this.data});

  ActivePrayerChallenge.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new ActiveChallenge.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ActiveChallenge {
  String dailyPrayer;
  String currentPrayerChallenge;
  String upcomingPrayerChallenge;

  ActiveChallenge(
      {this.dailyPrayer,
        this.currentPrayerChallenge,
        this.upcomingPrayerChallenge});

  ActiveChallenge.fromJson(Map<String, dynamic> json) {
    dailyPrayer = json['dailyPrayer'];
    currentPrayerChallenge = json['currentPrayerChallenge'];
    upcomingPrayerChallenge = json['upcomingPrayerChallenge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dailyPrayer'] = this.dailyPrayer;
    data['currentPrayerChallenge'] = this.currentPrayerChallenge;
    data['upcomingPrayerChallenge'] = this.upcomingPrayerChallenge;
    return data;
  }
}