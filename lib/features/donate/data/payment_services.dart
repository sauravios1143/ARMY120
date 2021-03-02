import 'dart:convert';
import 'package:army120/features/donate/data/model/stripe_transaction_response.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/utils/Constants/enumConst.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';



class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = "";//'sk_test_51Gov9NI0duVTaJ0qXSvYIVxaOS10gVk5VF9nj0HRdRPtbNQ0NnKEPWjaBk7AiHktYWfa4rhwX8Km82LSNXWm3xKU00UatOUnUc';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: ApiURL.stripePublishableKeyLive,
            merchantId: "Test",
            androidPayMode: 'production'
        )
    );
  }

 /* static Future<StripeTransactionResponse> payViaExistingCard({String amount, String currency, CreditCard card}) async{
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card)
      );
      var paymentIntent = await StripeService.createPaymentIntent(
          amount,
          currency
      );
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }
*/
  static Future<StripeTransactionResponse> payWithNewCard({String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(

          CardFormPaymentRequest()

      );
      var paymentIntent = await StripeService.createPaymentIntent(
          amount,
          currency
      );
      print("confirm");
      print("intedn -->${paymentIntent}");
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      print("response ---> ${response}");

      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      print("Perror -->$err");

      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      print("error -->$err");
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }
  static Future<PaymentMethod> getCardPayment()async{
    var paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(

        )
    );
    return paymentMethod;
  }

  static verifyPaymentIntend({paymentSecret,paymentMethod})async{

    print("method--> ${paymentMethod?.id} ${paymentSecret}");
    try{
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret:paymentSecret,
              paymentMethodId: paymentMethod.id,
          )
      );
      print("response ---> ${response}");

      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      print("Perror -->$err");

      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      print("error -->$err");
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }
  static verifySubscriptionIntent({paymentSecret,paymentMethod})async{

    print("method--> ${paymentMethod?.id} ${paymentSecret}");
    try{
      var response = await StripePayment.confirmSetupIntent(
          PaymentIntent(
              clientSecret:paymentSecret,
              paymentMethodId: paymentMethod.id,
          )
      );
      print("response ---> ${response}");

      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      print("Perror -->$err");

      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      print("error -->$err");
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
        message: message,
        success: false
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        // 'payment_method_types[]': 'card'
      };

      print("header----> ${headers}");
      print("header----> ${body}");
      var response = await http.post(
          StripeService.paymentApiUrl,
          body: body,
          headers: StripeService.headers
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
