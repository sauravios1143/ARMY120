import 'package:army120/features/donate/bloc/donation_bloc.dart';
import 'package:army120/features/donate/bloc/donation_event.dart';
import 'package:army120/features/donate/bloc/donation_state.dart';
import 'package:army120/features/donate/data/donation_repository.dart';
import 'package:army120/features/donate/data/model/DonationRequest.dart';
import 'package:army120/features/donate/data/model/stripe_transaction_response.dart';
import 'package:army120/features/donate/data/model/subscription_response.dart';
import 'package:army120/features/donate/data/payment_services.dart';
import 'package:army120/features/donate/ui/paymentSuccessState.dart';
import 'package:army120/utils/Constants/enumConst.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/ValidatorFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentScreen extends StatefulWidget {
  final Subscription subscriptions;

  PaymentScreen({this.subscriptions});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  //props
  Subscription _subscriptions;
  paymentType type;
  TextEditingController _amountController = new TextEditingController();
  DonationBloc _bloc;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //getters

  Widget get getRadioButtons {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        getRadioButton(value: paymentType.single),
        getRadioButton(value: paymentType.monthly),
      ],
    );
  }

  Widget get getAmountField {
    return appThemedTextField(
        context: context,
        controller: _amountController,
        hint: "Enter amount",
        label: "Enter Amount",
        focusNode: null,
        keyboardType: TextInputType.number,
        validator: (value) {
          return amountValidator(amount: value);
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly]);
  }

  Widget get getPayButton {
    return getAppThemedButton(
        verticalPadding: 8.0,
        title: "Pay",
        onpress: () {
          if (_formKey.currentState?.validate()) {
            // _makeSubscription();
            // _getPaymentIntent();
            makePaymentByCard();
            // makeStripePayment();

          }
        });
  }

  Widget get getSubscriptionButton {
    return Column(
      children: [
        getButton(
            // verticalPadding: 8.0,
            text: "Update Subscription",
            color: Colors.blue,
            onTap: () {
              if (_formKey.currentState?.validate()) {
                makePaymentByCard();
                // _makeSubscription();
              }
            }),
        getSpacer(height: 16),
        getButton(
          color: AppColors.primaryColor,
            // verticalPadding: 8.0,
            text: "Cancel Subscription",
            onTap: () {
              _deleteSubscription();
            }),

      ],
    );
  }

/*  Widget get getUpdateButton {
    return getAppThemedButton(
        verticalPadding: 8.0,
        title: "Cancel Subscription",
        onpress: () {
          _deleteSubscription();
        });
  }*/

  Widget get getView {
    double height = getScreenSize(context: context).height;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          getSpacer(height: height * 0.15),
          Form(key: _formKey, child: getAmountField),
          getSpacer(height: height * 0.05),
          Offstage(
              offstage: (_subscriptions?.recurringDonation != null),
              child: getRadioButtons),
          getSpacer(height: height * 0.05),
          Offstage(
              offstage: (_subscriptions?.recurringDonation != null),
              child: getPayButton),
          getSpacer(height: height * 0.05),
          Offstage(
              offstage: (_subscriptions?.recurringDonation == null),
              child: getSubscriptionButton),
          /*Offstage(
            offstage: !(_subscriptions),
              child: getCancelSubscriptionButton)*/
        ],
      ),
    );
  }

  //State methods

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("sub--${widget?.subscriptions}");
    _subscriptions = widget?.subscriptions;
    type = (_subscriptions.recurringDonation == null)
        ? paymentType.single
        : paymentType.monthly;

    // initializePayment();
    StripeService.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = BlocProvider.of<DonationBloc>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            closeKeyboard(context: context, onClose: () {});
          },
          child: Scaffold(
            key: _scaffoldKey,
            appBar: getAppThemedAppBar(context, titleText: getAppBarText()),
            body: getView,
          ),
        ),
        BlocBuilder<DonationBloc, DonationState>(
          builder: (context, state) {
            return Offstage(
              offstage: !(state is SubscriptionUpdatingState),
              child: CustomLoader(isTransparent: false),
            );
          },
        ),
        BlocListener<DonationBloc, DonationState>(
            child: Container(
              height: 0,
              width: 0,
            ),
            listener: (context, state) async {
              if (state is DonationErrorState) {
                showAlert(
                    context: context,
                    titleText: "Error",
                    message: state?.message ?? "",
                    actionCallbacks: {"Ok": () {}});
              }
              if (state is SubscriptionRemovedState) {
                showAlert(
                    context: context,
                    titleText: "Success",
                    message: "Subscription Removed Successfully",
                    actionCallbacks: {
                      "Ok": () {
                        Navigator.pop(context, 1);
                      }
                    });
              }
              if (state is SubscriptionSuccessState) {
                print("got Suceess");
                // verifyStipePayment(paymentSecret: state?.paymentToken);
                /* showAlert(
                    context: context,
                    titleText: "Success",
                    message: "Subscription Updated Successfully",
                    actionCallbacks: {"Ok": () {}});*/
              }
              if (state is StripePaymentSuccessState) {
                onPaymentComplete(state);
              }
            })
      ],
    );
  }

  Widget getRadioButton({paymentType value}) {
    Function onchange = (value) {
      //no need to change if already active
      if (value == type) {
        return;
      }

      setState(() {
        type = value;
      });
    };
    return InkWell(
      onTap: () {
        onchange(value);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.06),
            borderRadius: BorderRadius.circular(4)),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Radio(
              activeColor: AppColors.primaryColor,
              groupValue: type,
              value: value,
              onChanged: (value) {
                onchange(value);
              },
            ),
            Text(textButtonText(value)),
          ],
        ),
      ),
    );
  }

  String textButtonText(paymentType type) {
    String value;
    switch (type) {
      case paymentType.single:
        value = "One time";
        break;
      case paymentType.monthly:
        value = "monthly";
        break;
    }
    return value;
  }

  String getFrequency(paymentType type) {
    String value;
    switch (type) {
      case paymentType.single:
        value = "once";
        break;
      case paymentType.monthly:
        value = "repeat";
        break;
    }
    // value = "once";//todo remove
    return value;
  }

/*  _makeSubscription() {
    _bloc.add(MakeSubscription(
        paymentRequest: DonationRequst(
            amountInCents: double.tryParse(_amountController?.text ?? ""),
            frequency: getFrequency(type))));
  }*/

  makePaymentByCard() async {
    PaymentMethod method = await StripeService.getCardPayment(
    );

    if (method != null) {
      int amountInCent = int.tryParse(_amountController?.text ?? "");
      amountInCent = amountInCent * 100;
      _bloc.add(MakeStripePayment(
          paymentRequest: DonationRequst(
              amountInCents: amountInCent,
              paymentMethod: method,
              frequency: getFrequency(type))));
    }
  }

/*  _getPaymentIntent() async {
    int amountInCent = int.tryParse(_amountController?.text ?? "");
    amountInCent = amountInCent * 100;
    _bloc.add(MakeSubscription(
        paymentRequest: DonationRequst(
            amountInCents: amountInCent, frequency: getFrequency(type))));
  }*/

  _deleteSubscription() {
    _bloc.add(DeleteSubscription()); // todo remove
  }

/*  initializePayment() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: ApiURL.stripePublishableKey,
      //YOUR_PUBLISHABLE_KEY
      merchantId: "Test", //YOUR_MERCHANT_ID
      androidPayMode: 'test',
    ));
  }*/

/*  makeStripePayment() async {
    StripeTransactionResponse response = await StripeService.payWithNewCard(
        amount: _amountController.text ?? "0.0", currency: "usd");
    //todo show alert

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));

    if (response.success == true) {
      if (type == paymentType.monthly) {
        _makeSubscription(); // todo make substription on success
      }
      Navigator.pop(context, 1);
    }
    print("Response ${response.message}");
  }*/

/*  verifyStipePayment({String paymentSecret}) async {
    print("called");
    StripeTransactionResponse response =
        await StripeService.verifyPaymentIntend(paymentSecret: paymentSecret);
    //todo show alert

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));

    if (response.success == true) {
      if (type == paymentType.monthly) {
        _makeSubscription(); // todo make substription on success
      }
      Navigator.pop(context, 1);
    }
    print("Response ${response.message}");
  }*/
/*
  Future<StripeTransactionResponse> paymentWithCard() async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeService.createPaymentIntent(_amountController.text, "");
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }*/

  String getAppBarText() {
    String str = "";
    str = (_subscriptions?.recurringDonation == null)
        ? "Make Payment"
        : "Manage Payment";

    return str;
  }

  void onPaymentComplete(StripePaymentSuccessState state) {
    if (state?.response?.success ?? false) {
      showAlert(
          context: context,
          titleText: "Success",
          message: "${state?.response?.message}",
          actionCallbacks: {
            "Ok": () {
              Navigator.pop(context, 1);
             /* Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return BlocProvider(
                  create: (BuildContext context)=>DonationBloc(donationRepository: DonationRepository()),
                  child:
                  PaymentSuccessScreen(
                    amount: int.tryParse(_amountController.text??""),
                    subscription: widget?.subscriptions,
                  ),
                );
              }));*/
            }
          });
    } else {
      showAlert(
          context: context,
          titleText: "Error",
          message: "${state?.response?.message}",
          actionCallbacks: {"Ok": () {}});
    }
  }
}
// dK2kLtfeTx2N8WyA86g-Qi:APA91bGjIQpTCXXp5mtUDfnNxbCKZn2cSksyeO9zIyXbivxU0JQZBkcKURJjst7SPEQBK_D8AO27VyOpwm3AIeihCPBh8DSdBcEEPHWM1D9xfSe_s-eGuDGARBfq-mCH06vOlMrY3Vuf