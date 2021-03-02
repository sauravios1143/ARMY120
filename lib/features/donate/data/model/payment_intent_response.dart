class PaymentIntentResponse {
  String message;
  Data data;

  PaymentIntentResponse({this.message, this.data});

  PaymentIntentResponse.fromJson(Map<String, dynamic> json) {
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
  String intentSecret;

  Data({this.intentSecret});

  Data.fromJson(Map<String, dynamic> json) {
    intentSecret = json['intentSecret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intentSecret'] = this.intentSecret;
    return data;
  }
}