import 'package:army120/features/events/data/model/event.dart';

class EventListResponse {
  String message;
  List<Event> data;

  EventListResponse({this.message, this.data});

  EventListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Event>();
      json['data'].forEach((v) {
        data.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

