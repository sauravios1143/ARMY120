import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  bool needBackButton=true;
  HeaderWidget({this.needBackButton:true});
  @override
  Widget build(BuildContext context) {
    return Stack(

      children: <Widget>[
        Container(
          height:getScreenSize(context: context).height*0.25,
          width: double.infinity,
          child: Image.asset(
           AssetStrings.logo,fit: BoxFit.cover
         ),



        ),
        Positioned(
            top: 15,left: 10,
            child:Offstage(
              offstage: !needBackButton,
              child: Material(
//              color: Colors.white.withOpacity(0.8),
                color:Colors.black..withOpacity(0.5),
                elevation: 4,
                shape: CircleBorder(),
                child: IconButton(
                  icon: Icon(Icons.arrow_back,color:Colors.white /*AppColors.primaryColor*/,size: 28,), onPressed: (){
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                },
                ),
              ),
            )
        ),
      ],
    );
  }
}
