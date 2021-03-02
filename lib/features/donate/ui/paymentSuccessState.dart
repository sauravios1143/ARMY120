import 'package:army120/features/donate/bloc/donation_bloc.dart';
import 'package:army120/features/donate/bloc/donation_event.dart';
import 'package:army120/features/donate/bloc/donation_state.dart';
import 'package:army120/features/donate/data/donation_repository.dart';
import 'package:army120/features/donate/data/model/DonationRequest.dart';
import 'package:army120/features/donate/data/model/stripe_transaction_response.dart';
import 'package:army120/features/donate/data/model/subscription_response.dart';
import 'package:army120/features/donate/data/payment_services.dart';
import 'package:army120/features/donate/ui/paymentView.dart';
import 'package:army120/network/api_urls.dart';
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

class PaymentSuccessScreen extends StatefulWidget {
  final int amount;
  final Subscription subscription;

  PaymentSuccessScreen({this.amount, this.subscription});

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  //props
  paymentType type;
  TextEditingController _amountController = new TextEditingController();
  DonationBloc _bloc;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //getters

  Widget get getDonatedAmount {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "You've Donated ",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          "${widget?.amount ?? ""}",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor),
        )
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

  Widget get getPayMOreButton {
    return getAppThemedFilledButton(
        onpress: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return BlocProvider(
                create: (BuildContext context) =>
                    DonationBloc(donationRepository: DonationRepository()),
                child: PaymentScreen(
                  subscriptions: widget?.subscription,
                ));
          }));
        },
        title: (widget?.subscription?.recurringDonation==null)?"Donate more":"Manage Donation");
  }

  Widget get getTextMessage {
    return Text("ss");
  }

  Widget get getView {
    double height = getScreenSize(context: context).height;
    return SingleChildScrollView(
      // padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          getSpacer(height: height * 0.05),
          getDonatedAmount,
          Divider(
            thickness: 8,
          ),
          getSpacer(height: height * 0.05),
          getTextMessage,
          Divider(
            thickness: 8,
          ),
        ],
      ),
    );
  }

  //State methods

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    type = paymentType.single;
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
            appBar: getAppThemedAppBar(context),
            body: getView,
            bottomNavigationBar: getPayMOreButton,
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
                    actionCallbacks: {"Ok": () {}});
              }
              if (state is SubscriptionSuccessState) {
                showAlert(
                    context: context,
                    titleText: "Success",
                    message: "Subscription Updated Successfully",
                    actionCallbacks: {"Ok": () {}});
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
    return value;
  }

  _makeSubscription() {
    _bloc.add(MakeSubscription(
        paymentRequest: DonationRequst(
            amountInCents: double.tryParse(_amountController?.text ?? ""),
            frequency: getFrequency(type))));
  }

  _deleteSubsciptions() {
    _bloc.add(DeleteSubscription());
  }

/*  initializePayment() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: ApiURL.stripePublishableKey,
      //YOUR_PUBLISHABLE_KEY
      merchantId: "Test", //YOUR_MERCHANT_ID
      androidPayMode: 'test',
    ));
  }*/

  makeStripePayment() async {
    StripeTransactionResponse response = await StripeService.payWithNewCard(
        amount: _amountController.text ?? "0.0", currency: "usd");
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
    print("Response ${response.message}");
  }

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
  }
}
