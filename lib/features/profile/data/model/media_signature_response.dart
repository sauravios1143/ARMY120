class MediaSignatureResponse {
  String url;
  String thumbnailUrl;
  String kind;
  String formPostUrl;
  List<LocalFormData> formData;

  MediaSignatureResponse(
      {this.url,
        this.thumbnailUrl,
        this.kind,
        this.formPostUrl,
        this.formData});

  MediaSignatureResponse.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
    kind = json['kind'];
    formPostUrl = json['formPostUrl'];
    if (json['formData'] != null) {
      formData = new List<LocalFormData>();
      json['formData'].forEach((v) {
        formData.add(new LocalFormData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['kind'] = this.kind;
    data['formPostUrl'] = this.formPostUrl;
    if (this.formData != null) {
      data['formData'] = this.formData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocalFormData {
  String key;
  String value;

  LocalFormData({this.key, this.value});

  LocalFormData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}