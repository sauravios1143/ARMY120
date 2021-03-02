import 'package:stripe_payment/stripe_payment.dart';
class DonationRequst {
  String frequency;
  num amountInCents;
  PaymentMethod paymentMethod;
  DonationRequst({this.frequency, this.amountInCents,this.paymentMethod});

  DonationRequst.fromJson(Map<String, dynamic> json) {
    frequency = json['frequency'];
    amountInCents = json['amount_in_cents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['frequency'] = this.frequency;
    data['amount_in_cents'] = this.amountInCents;
    return data;
  }
}
