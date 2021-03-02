import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  final bool isTransparent;
  CustomLoader({this.isTransparent:true});
  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:widget?.isTransparent??true?Colors.transparent:Colors.black.withOpacity(0.3),
      alignment: Alignment.center,
      child:CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      )
//      CupertinoActivityIndicator(
//
//        radius: 18,
//      )
    );
  }
}
