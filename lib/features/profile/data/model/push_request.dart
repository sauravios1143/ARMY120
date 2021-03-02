class PushRequest {
  bool pushAlarm;
  bool superAlarm;
  String token;

  PushRequest({this.pushAlarm, this.superAlarm, this.token});

  PushRequest.fromJson(Map<String, dynamic> json) {
    pushAlarm = json['pushAlarm'];
    superAlarm = json['superAlarm'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pushAlarm'] = this.pushAlarm;
    data['superAlarm'] = this.superAlarm;
    data['token'] = this.token;
    data['platform'] = 'android';//todo
    return data;
  }
}