class ProfilePicture {
  String url;
  String thumbnailUrl;
  String kind;

  ProfilePicture({this.url, this.thumbnailUrl, this.kind});

  ProfilePicture.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
    kind = json['kind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url??"";
    data['thumbnailUrl'] = this.thumbnailUrl??"";
    data['kind'] = this.kind??"";
    return data;
  }
}