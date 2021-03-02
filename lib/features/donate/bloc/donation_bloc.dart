import 'package:army120/features/donate/bloc/donation_event.dart';
import 'package:army120/features/donate/bloc/donation_state.dart';
import 'package:army120/features/donate/data/donation_repository.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonationBloc extends Bloc<DonationEvent, DonationState> {
  DonationRepository donationRepository;

  DonationBloc({@required this.donationRepository});

  @override
  DonationState get initialState => DonationIdleState();

  @override
  Stream<DonationState> mapEventToState(DonationEvent event) async* {
    print("Event $event");

    // get Subscriptioins
    if (event is FetchSubscription) {
      //Fetch prayer listing
      yield SubscriptionUpdatingState();

      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield DonationErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await donationRepository.fetchSubscription();
        yield FetchSubscriptionSuccessState(subscription: x.data);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield DonationErrorState(message: e.toString());
      }
    }

    // Create new Post
    if (event is MakeSubscription) {
      //Fetch prayer listing
      yield SubscriptionUpdatingState();

      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield DonationErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await donationRepository.addSubscription(
            request: event.paymentRequest);
        yield SubscriptionSuccessState(paymentToken: x?.data?.intentSecret);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield DonationErrorState(message: e.toString());
      }
    }

    // make payment
    if (event is MakeStripePayment) {
      //Fetch prayer listing
      yield SubscriptionUpdatingState();

      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield DonationErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await donationRepository.makePayment(
            request: event.paymentRequest);
        yield StripePaymentSuccessState(response: x);
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield DonationErrorState(message: e.toString());
      }
    }

    //add subscription
    if (event is DeleteSubscription) {
      yield SubscriptionUpdatingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield DonationErrorState(message: AppMessages.noInternet);
          return;
        }

        var x = await donationRepository.deleteSubcription();
        yield SubscriptionRemovedState();
      } catch (e, st) {
        print("Exception $e, \n$st");
        //todo
        yield DonationErrorState(message: e.toString());
      }
    }
  }
}
