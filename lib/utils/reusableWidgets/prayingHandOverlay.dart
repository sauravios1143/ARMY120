import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/reusableWidgets/prayingHandAnimation.dart';
import 'package:flutter/material.dart';

class PrayingHandView{
  OverlayEntry overlayEntry;


  void showPrayingHands(BuildContext context) {
    autoRemove();
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 0.0,
          left: 0.0,
          child: Container(
            height: getScreenSize(context: context).height,
            width: getScreenSize(context: context).width,
              child: PayingHandAnimation())
        );
      },
    );
    Overlay.of(context).insert(overlayEntry);
  }
  void hideIndicator() {
    overlayEntry?.remove();
  }
  autoRemove()async{
    await Future.delayed(Duration(
      seconds: 2
    ));
    overlayEntry.remove();
  }
}