import 'package:army120/features/donate/data/model/DonationRequest.dart';
import 'package:flutter/foundation.dart';

//Event Events
abstract class DonationEvent {
  const DonationEvent();
}

//Fetch Event list
class FetchSubscription extends DonationEvent {
//  const FetchEvent();
}

//Fetch Event list
class MakePaymentEvent extends DonationEvent {
  DonationRequst paymentRequest;

  MakePaymentEvent({@required this.paymentRequest});
}

class MakeSubscription extends DonationEvent {
  DonationRequst paymentRequest;

  MakeSubscription({@required this.paymentRequest});
}
class MakeStripePayment extends DonationEvent {
  DonationRequst paymentRequest;

  MakeStripePayment({@required this.paymentRequest});
}

class DeleteSubscription extends DonationEvent {
  DeleteSubscription();
}
