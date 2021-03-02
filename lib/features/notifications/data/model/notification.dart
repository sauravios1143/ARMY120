class NotificationItem {
  int id;
  String kind;
  String title;
  String text;
  int object;
  Data data;
  String postedAt;

  NotificationItem(
      {this.id,
      this.kind,
      this.title,
      this.text,
      this.object,
      this.data,
      this.postedAt});

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kind = json['kind'];
    title = json['title'];
    text = json['text'];
    object = int.tryParse(json['object']?.toString()??"");
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    postedAt = json['postedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kind'] = this.kind;
    data['title'] = this.title;
    data['text'] = this.text;
    data['object'] = this.object;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['postedAt'] = this.postedAt;
    return data;
  }
}

class Data {
  String reason;
  String icon;
  String identifier;

  Data({this.reason, this.icon, this.identifier});

  Data.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    icon = json['icon'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    data['icon'] = this.icon;
    data['identifier'] = this.identifier;
    return data;
  }
}
