import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/data/profile_repository.dart';
import 'package:army120/features/profile/ui/profile_widget.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/memory_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompeteProfileView extends StatefulWidget {
  @override
  _CompeteProfileViewState createState() => _CompeteProfileViewState();
}

class _CompeteProfileViewState extends State<CompeteProfileView> {
  @override
  Widget build(BuildContext context) {
    double height = getScreenSize(context: context).height;
    return Container(
      height: height*0.5,
      // color:Colors.white.withOpacity(0.9),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Profile Setup",style: TextStyle(
                fontSize: 20,fontWeight: FontWeight.bold
              ),),
            ),
            getSpacer(height:height*0.04 ),
            BlocProvider(
                create: (context) => ProfileBloc(repository: ProfileRepository()),
                child: ProfileWidget()),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: getButton(text: "Skip",color: AppColors.primaryColor,onTap: skipStep),
            )
          ],
        ),
      ),
    );
  }

  Widget getButton({String text, onTap, color}) {
    return Material(
      elevation: 0.4,
      clipBehavior: Clip.hardEdge,
      color: color,
      shape: StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          alignment: Alignment.center,
          width: double.maxFinite,
          child: Text(
            text ?? "",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
  skipStep()async{
    await MemoryManagement.setIsProfileCompleted(isProfileCompleted: true);
    Navigator.pop(context);

  }
}
