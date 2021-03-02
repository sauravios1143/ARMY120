import 'package:army120/features/donate/data/model/DonationRequest.dart';
import 'package:army120/features/donate/data/model/payment_intent_response.dart';
import 'package:army120/features/donate/data/model/stripe_transaction_response.dart';
import 'package:army120/features/donate/data/model/subscription_response.dart';
import 'package:army120/features/donate/data/payment_services.dart';
import 'package:army120/network/apiError.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DonationRepository {
  //fetch Event Listing
  Future<Null> fetchEvents() async {
    try {
      var response = await RestClient.dio.get(ApiURL.getEvents);
      if (response.statusCode == 200) {
        var data = response.data;
        // EventListResponse prayersResponse = EventListResponse.fromJson(data);
        return null; // prayersResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }

  //fetch Subscription detail
  Future<SubsriptionResponse> fetchSubscription() async {
    try {
      var response = await RestClient.dio.get(ApiURL.donation);
      if (response.statusCode == 200) {
        var data = response.data;
        SubsriptionResponse prayersResponse =
            SubsriptionResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }

  //Update Subscriptions
  Future<PaymentIntentResponse> addSubscription({@required DonationRequst request}) async {
    // print("--${}")
    try {
      var response =
          await RestClient.dio.post(ApiURL.donation, data: request?.toJson());
      if (response.statusCode == 200) {
        var data = response.data;
        print("data ${data}");
        PaymentIntentResponse prayersResponse =
        PaymentIntentResponse.fromJson(data);
        return prayersResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }  //Update Subscriptions
  Future<StripeTransactionResponse> makePayment({@required DonationRequst request}) async {
    // print("--${}")
    try {
      var response =
          await RestClient.dio.post(ApiURL.donation, data: request?.toJson());
      if (response.statusCode == 200) {
        var data = response.data;
        print("data ${data}");
        PaymentIntentResponse prayersResponse =
        PaymentIntentResponse.fromJson(data);
        StripeTransactionResponse paymentResponse ;

        if(request?.frequency=="repeat"){
          paymentResponse = await StripeService.verifySubscriptionIntent(
              paymentSecret: prayersResponse?.data?.intentSecret,
              paymentMethod: request?.paymentMethod
          );
        }else{
          paymentResponse = await StripeService.verifyPaymentIntend(
              paymentSecret: prayersResponse?.data?.intentSecret,
              paymentMethod: request?.paymentMethod
          );
        }

        return paymentResponse;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }

  //Delete Subscriptions
  Future<bool> deleteSubcription() async {
    try {
      var response = await RestClient.dio.delete(ApiURL.donation);
      if (response.statusCode == 200) {
        var data = response.data;
        print("data ${data}");
        /* SubsriptionResponse prayersResponse =
            SubsriptionResponse.fromJson(data);*/
        return true;
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    } catch (e, st) {
      print("Exception $e,$st");

      if (e is DioError) {
        throw commonErrorHandler(e);
      } else {
        throw ApiException(message:AppMessages?.commonError);
      }
    }
  }
}
// seti_1HwMtBI0duVTaJ0q5oiCmDtG_secret_IXRmGUKnW5hHJMdjqKx5W4ZbITW4Ryp
