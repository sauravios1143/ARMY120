import 'package:army120/network/api_urls.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueKatServices {
  //init
  static Future<void> initPlatformState() async {
    var x = await Purchases.setDebugLogsEnabled(true);

    var y = await Purchases.setup(ApiURL.revnuekatKey).then((value) {
      print("-----> done ");
    });

  }




//identify user
  static identifyUser({String id}) async {
    var x = await Purchases.identify(id);
    print("---> rev user $x");
  }

  //get products
  static Future getOffering() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      print("offering -> ${offerings}");
     return offerings;
    } on PlatformException catch (e) {
      print("platform e ${e}");
      // optional error handling
    }
  }

  //purchase products
  static makePurchase(package) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      return purchaserInfo;
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print("error --> $e");
        // showError(e);//todo
      }
    }
  }

  //get purchaser info
  static Future<PurchaserInfo>  getPurchaserInfo() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
     return purchaserInfo;
    } on PlatformException catch (e) {
      // Error fetching purchaser info
    }
  }

  //listenfor for update
  static getPurchaseUpdate() {
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) => {
          print("-----listened ${purchaserInfo}")
          // handle any changes to purchaserInfo
        });
  }
}
