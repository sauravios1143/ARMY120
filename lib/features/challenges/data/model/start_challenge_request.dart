class StartChallengeRequest {
  int group;
  String category;
  String text ;

  StartChallengeRequest({this.group, this.category,this.text});

  StartChallengeRequest.fromJson(Map<String, dynamic> json) {
    group = json['group'];
    category = json['category'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.group != null) {
      data['group'] = this.group;
    }
    if (this.text != null) {
      data['text'] = this.text;
    }
    data['category'] = this.category;
    return data;
  }
}
