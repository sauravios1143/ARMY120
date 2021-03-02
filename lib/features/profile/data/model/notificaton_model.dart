class PushResponse {
  String message;
  PushData data;

  PushResponse({this.message, this.data});

  PushResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new PushData.fromJson(json['data']) : null;
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

class PushData {
  bool pushAlarm;
  bool superAlarm;

  PushData({this.pushAlarm, this.superAlarm});

  PushData.fromJson(Map<String, dynamic> json) {
    pushAlarm = json['pushAlarm'];
    superAlarm = json['superAlarm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pushAlarm'] = this.pushAlarm;
    data['superAlarm'] = this.superAlarm;
    return data;
  }
}