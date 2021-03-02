import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final bool needBack;
  final String title;
  final Widget trailing ;
  CustomAppBar({this.needBack,this.title,this.trailing});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
//      height: getScreenSize(context: context).height * 0.13,
    padding: EdgeInsets.only(
      top: getScreenSize(context: context).height * 0.04,
      left: getScreenSize(context: context).height * 0.02,
      right: getScreenSize(context: context).height * 0.02,
      bottom: getScreenSize(context: context).height * 0.02,

    ),
     child: Column(

       children: <Widget>[
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             InkWell(
                 onTap: () {
                   Navigator.pop(context);
                 },
                 child: Icon(
                   Icons.arrow_back,
                   color: AppColors.primaryColor,
                   size: 30,
                 )),
             widget.trailing??Container(height: 0,width: 0,),
           ],

         ),
         Text(
           widget?.title??"",
           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
         )

       ],
     ),
    );
  }
}
