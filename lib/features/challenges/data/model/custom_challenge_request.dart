class CustomChallengeRequest {
  String category;
  String text;

  CustomChallengeRequest({
    this.category,
    this.text,
  });

  CustomChallengeRequest.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['text'] = this.text;

    return data;
  }
}
