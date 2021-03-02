class NewPostRequest {
  String text;
  bool isAnonymous;
  int groupId;

  NewPostRequest(
      {this.text,
        this.isAnonymous,this.groupId});

  NewPostRequest.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    isAnonymous = json['isAnonymous'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['isAnonymous'] = this.isAnonymous;
    if(groupId !=null){
      data['group'] = this.groupId;
    }
    return data;
    return data;
  }

}