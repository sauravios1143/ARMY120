import 'dart:convert';

import 'package:army120/features/group/data/revenukat_services.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/utils/Constants/enumConst.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

PurchaserInfo _purchaserInfo;

class CreateNewGroupPopUp extends StatefulWidget {
  @override
  _CreateNewGroupPopUpState createState() => _CreateNewGroupPopUpState();
}

class _CreateNewGroupPopUpState extends State<CreateNewGroupPopUp> {
  Offerings _offerings;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
          child: GridView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount: 2,
                childAspectRatio: 0.8),
            children: [
              getCard(
                  title: "Free",
                  heade1: "add up to 6 people",
                  head2: "Free to create and use",

                  // head2: "${_offerings?.current?.monthly?.product?.priceString}",
                  onTap: () {
                    Navigator.pop(context, groupType.free);
                  }),
              getCard(
                title: (isSubscribed()) ? "Community" : "Unlock Community",
                // _offerings?.current == null ? "UnlockCommunity" : "Community",
                heade1: "add up to 200 people",
                head2:
                    "${_offerings?.current?.monthly?.product?.priceString} per month",
                onTap: onCommunityTap,
              ),
            ],
          ),
        )
        /* Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getCard(
                title: "Free",
                heade1: "add up to 6 people",
                head2: "Free to create and use",

                // head2: "${_offerings?.current?.monthly?.product?.priceString}",
                onTap: () {
                  Navigator.pop(context, groupType.free);
                }),
            getCard(
              title: (isSubscribed()) ? "Community" : "Unlock Community",
              // _offerings?.current == null ? "UnlockCommunity" : "Community",
              heade1: "add up to 200 people",
              head2:
                  "${_offerings?.current?.monthly?.product?.priceString} per month",
              onTap: onCommunityTap,
            ),
          ],
        ),*/
      ],
    );
  }

  getCard({title, heade1, head2, onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Container(
          // width: getScreenSize(context: context).width * 0.4,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                getSpacer(height: 12),
                Text(heade1 ?? ""),
                getSpacer(height: 8),
                Text(head2 ?? ""),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //methods
  onCommunityTap() {
    //todo do somethign

    print("--> ${_purchaserInfo?.activeSubscriptions?.length}");
    print("--2> ${_offerings?.current?.monthly?.product?.identifier}");

    var purchaserInfo =
        RevenueKatServices.makePurchase(_offerings?.current?.monthly);

    var isPro =
        purchaserInfo.entitlements.all["${ApiURL.purchaseKey}"].isActive;
    if (isPro) {
      Navigator.pop(context, groupType.community);
    }
  }

  Future<void> fetchData() async {
    PurchaserInfo purchaserInfo;

    purchaserInfo = await RevenueKatServices.getPurchaserInfo();

    Offerings offerings;

    offerings = await RevenueKatServices.getOffering();

    if (!mounted) return;
    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
  }

  bool isSubscribed() {
    if (_purchaserInfo?.entitlements?.all?.isNotEmpty ?? false) {
      return _purchaserInfo
              ?.entitlements?.all["${ApiURL.purchaseKey}"]?.isActive ??
          false;
    } else {
      return false;
    }
  }
}
