import 'dart:async';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../ReusableWidgets.dart';

class ProgressIndicatorBar extends StatefulWidget {
  final num totalValue;
  final num filledValue;

  ProgressIndicatorBar({
    Key key,

    @required this.totalValue,
    @required this.filledValue,
  }) : super(key: key);

  // UI props


  @override
  _ProgressIndicatorBarState createState() => _ProgressIndicatorBarState();
}

class _ProgressIndicatorBarState extends State<ProgressIndicatorBar> {
  @override
  Widget build(BuildContext context) {
    double barWidth= getScreenSize(context: context).width-24;
    // TODO: implement build
    return Container(
      alignment: Alignment(-1,0),
      width:barWidth,
      height: 10,
      decoration: new BoxDecoration(
        color: Colors.grey,
        borderRadius: new BorderRadius.circular(10.0),

      ),
      child: AnimatedContainer(
        height: 10,
        duration: Duration(seconds: 2),
        width: ((barWidth*(widget.filledValue??0.0)))/100,
        decoration: new BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: new BorderRadius.circular(10.0),

        ),

      ),
    );
  }

}