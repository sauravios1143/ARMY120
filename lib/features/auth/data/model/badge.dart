class Badges {
  String reason;
  String icon;

  Badges({this.reason, this.icon});

  Badges.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    data['icon'] = this.icon;
    return data;
  }
}