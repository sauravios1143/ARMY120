class Event {
  int id;
  String name;
  String kind;
  String description;
  String location;
  String startDateTime;
  String endDateTime;
  String postedAt;
  bool isBookmarked;

  Event(
      {this.id,
        this.name,
        this.kind,
        this.description,
        this.location,
        this.startDateTime,
        this.endDateTime,
        this.postedAt});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    kind = json['kind'];
    description = json['description'];
    location = json['location'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    postedAt = json['postedAt'];
    isBookmarked = json['isBookmarked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['kind'] = this.kind;
    data['description'] = this.description;
    data['location'] = this.location;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['postedAt'] = this.postedAt;
    data['isBookmarked'] = this.isBookmarked;
    return data;
  }
}