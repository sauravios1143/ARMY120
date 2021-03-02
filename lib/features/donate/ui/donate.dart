import 'package:army120/features/donate/bloc/donation_bloc.dart';
import 'package:army120/features/donate/bloc/donation_event.dart';
import 'package:army120/features/donate/bloc/donation_state.dart';
import 'package:army120/features/donate/data/donation_repository.dart';
import 'package:army120/features/donate/data/model/subscription_response.dart';
import 'package:army120/features/donate/ui/paymentView.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_appbar.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Donation extends StatefulWidget {
  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  //Properties
  bool _gotData = false;
  DonationBloc _bloc;
  Subscription subscription;

  // Getters
  get getTopBar {
    return CustomAppBar(
      title: "Donate to 120 team",
      trailing: getAppThemedFilledButton(title: "Share", onpress: () {}),
    );
  }

  get getTextMessage {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: getScreenSize(context: context).height * 0.08,
          horizontal: 8),
      child: Text(
          "Donate to help us spread the word of the true power of united and focused prayer",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center),
    );
  }

  get getImageHeader {
    double _size = getScreenSize(context: context).width * 0.4;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: getScreenSize(context: context).height * 0.06,
          horizontal: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "We are church and this town is our sanctuary",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
//        Icon(Icons.favorite,color: AppColors.primaryColor,size: 70,)
          Image.asset(
            AssetStrings.donateHeart,
            width: _size,
            height: _size,
          ),
        ],
      ),
    );
  }

  get getHeaderBox {
    double _size = getScreenSize(context: context).height * 0.25;
    return Container(
      height: _size,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("You have Donated",style: TextStyle(
            fontWeight: FontWeight?.bold,fontSize: 18
          ),),

          getSpacer(height: 8),
          Text("\$${(subscription?.donationsSum??0)/100}",style: TextStyle(
            fontWeight: FontWeight?.bold,fontSize: 24,color: AppColors.primaryColor
          ),),
        ],
      ),
    );
  }
  get getSubscriptionAmount{
    return Offstage(
      offstage: (subscription?.recurringDonation==null),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90) ,
          color: AppColors.ultraLightBGColor
        ),
        child:Text("You donte \$${(subscription?.recurringDonation?.amount??0)/100} every month",style: TextStyle(fontWeight: FontWeight?.bold),),
      ),
    );
}
  get getDonatedTextMessage {
    double _size = getScreenSize(context: context).height * 0.1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          (subscription?.recurringDonation==null)?AppMessages.oneTimeDonationText:AppMessages.monthlyDonationText,
        style: TextStyle(
          fontSize: 16,
        ),textAlign: TextAlign.center,
      ),
    );
  }
  get getDonationButton{
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: getButton(
        color: AppColors.primaryColor,
        text: (subscription?.recurringDonation==null)?"Donate more":"Mange Donation",
        onTap: moveToPayment
      ),
    );

    /*  getAppThemedFilledButton(
      onpress:
      moveToPayment
      ,
      title:  (subscription?.recurringDonation==null)?"Donate more":"Mange Donation"
    );*/
  }

  //get contribution button
  get getButtons {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: moveToPayment,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryColor, width: 4)),
          child: Wrap(
            spacing: 10,
            children: <Widget>[
              Text(
                "Make your Contribution",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Image.asset(AssetStrings?.handHeart,height: 30,width: 30,),
            ],
          ),
        ),
      ),
    );
  }

  Widget get getViewAccordingToDontaion{
print("sub ${subscription?.donationsSum}");
    return ((subscription?.donationsSum??0 )!= 0)?getView:getDonatedView;

  }

  Widget get getView {
    double height= getScreenSize(context: context).height;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // getTopBar,
          getHeaderBox,
          Divider(
            thickness: 8,
          ),
          getSpacer(
            height: height*0.04,
          ),
          getDonatedTextMessage,
          getSpacer(
            height: height*0.04,
          ),
          getSubscriptionAmount,
          getDonationButton
        ],
      ),
    );
  }
  Widget get getDonatedView{
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // getTopBar,
            getImageHeader,
            Divider(
              thickness: 8,
            ),
            getTextMessage,
            getButtons
          ],
        ),
      ),
    );
  }

  //state methods
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = BlocProvider.of<DonationBloc>(context);
      getSubscription();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        BlocBuilder<DonationBloc, DonationState>(builder: (context, state) {
      return Builder(
        builder: (context) {
          Widget _child;
          if (state is FetchSubscriptionSuccessState) {
            setData(state: state);
            _child = getViewAccordingToDontaion;
          } else if (state is SubscriptionUpdatingState ||
              state is DonationIdleState) {
            _child = CustomLoader();
          } else if (state is DonationErrorState && !_gotData) {
            _child = getNoDataView(
                msg: state?.message,
                onRetry: () {
                  getSubscription();
                });
          } else {
            _child = getViewAccordingToDontaion;
          }

          return _child;
        },
      );
    }));
  }

  //fetch subscriptions
  getSubscription() {
    _bloc.add(FetchSubscription());
  }

  //set subscription data
  setData({FetchSubscriptionSuccessState state}) {
    subscription = state?.subscription;
    print("--sub ${subscription?.donationsSum}");
    _gotData=true;
  }


  moveToPayment() async{
    var x = await  Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider(
        create: (BuildContext context) =>
            DonationBloc(donationRepository: DonationRepository()),
        child: PaymentScreen(
          subscriptions: subscription,
        ),
      );
    }));
    print("got---> ${x}");
    if(x == 1) {
      _gotData=false;
      getSubscription();
     /* setState(() {
        subscription = null;
      });*/
    }
  }
}
// eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJlbWFpbCI6ImRldjFAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiRGV2In0.KvpweuDuuMH01tpHhFaPIUpOOQA-EklEKHepVOr4HEEb53CEEp1WTgBScLY7wBmkKRnwjw4S_ICH-i89VxwJjXoR5cdHg_XUei1LclkDoG1VbS9UoLSz4Gkk6upRvmpKskbCfGU8aNyOnBiFSNKDddwcWCU2FmuBOBpN-w1TLx0jXV8_6XGrT7Bq8wnTJGBR7XQ7uIjE9cYmhUZoRlEND-BTOyE0WOjHZUukj9lMwFDHWgFpGLE9l4zIwZFFDXqTCLC0N8tVaCqeIoyhgO4ztAnfAhyMxNxAgJ1nby7pHSbIwIitqhW-dfvo5A-X9ruxuYIlnms3avYT3zGELlwVcg
