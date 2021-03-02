
import 'package:army120/features/notifications/data/model/notification.dart';

class NotificationListingResponse {
  String message;
  Data data;

  NotificationListingResponse({this.message, this.data});

  NotificationListingResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<NotificationItem> notifications;

  Data({this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = new List<NotificationItem>();
      json['notifications'].forEach((v) {
        notifications.add(new NotificationItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

