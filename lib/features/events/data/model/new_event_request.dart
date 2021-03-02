class NewEventRequest {
  String name ;
  String  groupIcon;

  NewEventRequest(
      {this.name,
        this.groupIcon});

  NewEventRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    groupIcon = json['icon'];
  }




  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.groupIcon;
    return data;
  }
}