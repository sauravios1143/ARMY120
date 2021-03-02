import 'package:army120/features/donate/data/model/stripe_transaction_response.dart';
import 'package:army120/features/donate/data/model/subscription_response.dart';
import 'package:army120/features/events/data/model/create_event_response.dart';
import 'package:army120/features/events/data/model/event.dart';
import 'package:flutter/foundation.dart';

abstract class DonationState {}

class DonationIdleState extends DonationState {}

class MakePaymentState extends DonationState {}

class PaymentProcessingState extends DonationState {}

class PaymentSuccessState extends DonationState {}

class SubscriptionSuccessState extends DonationState {
  String paymentToken ;
  SubscriptionSuccessState({this.paymentToken});
}

class StripePaymentSuccessState extends DonationState {
  StripeTransactionResponse response;
  StripePaymentSuccessState({this.response});
}

class FetchSubscriptionSuccessState extends DonationState {
  Subscription subscription;
  FetchSubscriptionSuccessState({this.subscription});
}

class SubscriptionRemovedState extends DonationState {}

class SubscriptionUpdatingState extends DonationState {}

class DonationErrorState extends DonationState {
  String message;

  DonationErrorState({this.message});
}
