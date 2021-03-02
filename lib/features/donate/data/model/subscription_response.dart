class SubsriptionResponse {
  String message;
  Subscription data;

  SubsriptionResponse({this.message, this.data});

  SubsriptionResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Subscription.fromJson(json['data']) : null;
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
class Subscription {
  RecurringDonation recurringDonation;
  int donationsSum;

  Subscription({this.recurringDonation, this.donationsSum});

  Subscription.fromJson(Map<String, dynamic> json) {
    recurringDonation = json['recurringDonation'] != null
        ? new RecurringDonation.fromJson(json['recurringDonation'])
        : null;
    donationsSum = json['donationsSum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.recurringDonation != null) {
      data['recurringDonation'] = this.recurringDonation.toJson();
    }
    data['donationsSum'] = this.donationsSum;
    return data;
  }
}

class RecurringDonation {
  int id;
  int user;
  num amount;
  String createdAt;
  String frequency;
  bool error;

  RecurringDonation(
      {this.id,
        this.user,
        this.amount,
        this.createdAt,
        this.frequency,
        this.error});

  RecurringDonation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    amount = json['amount'];
    createdAt = json['createdAt'];
    frequency = json['frequency'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    data['frequency'] = this.frequency;
    data['error'] = this.error;
    return data;
  }
}