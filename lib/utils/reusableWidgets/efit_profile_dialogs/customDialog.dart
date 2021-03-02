import 'dart:io';
import 'package:army120/features/profile/data/model/update_profile_request.dart';
import 'package:army120/utils/AssetStrings.dart';
import 'package:army120/utils/Constants/next_step.dart';
import 'package:army120/utils/Constants/profileConstant.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class EditProfileCards extends StatefulWidget {
//  ProfileStatus status;
  String step;

  EditProfileCards({this.step});

  @override
  _EditProfileCardsState createState() => _EditProfileCardsState();
}

class _EditProfileCardsState extends State<EditProfileCards> {
  TextStyle headerSytle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  TextStyle bodySytle = TextStyle(fontSize: 16);
  bool _selectedCheckBox = false;
  DateTime _dob;
  gender _gender;
  File _image;
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  UpdateProfileRequest request = UpdateProfileRequest();

  get getSeparator {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(
        height: 1,
        color: AppColors.primaryColor,
      ),
    );
  }

  get getGenderDialog {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Your Gender",
            style: headerSytle,
          ),
          getSpacer(height: 8),
          Text(
            "We need this to complete your profile",
            style: bodySytle,
          ),
          getSpacer(height: 8),
          getSeparator,
          gerRadioTile(gender.male, "male"),
          gerRadioTile(gender.female, "female"),
          gerRadioTile(gender.undefined, "Non-Conforming"),
          getAppThemedChipButton(
              onpress: () {
                onGenderSubmit();
              },
              title: "Submit"),
        ],
      ),
    );
  }

  gerRadioTile(value, text) {
    return Row(
      children: [
        Radio(
//            dense: true,
          groupValue: _gender,
          value: value,
          activeColor: AppColors.primaryColor,
//            title: Text("Non-Conforming"),
          onChanged: _selectGender,
        ),
        Text(text ?? ""),
      ],
    );
  }

  get getImageDialog {
    double imageSize = 80;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Select a Picture",
            style: headerSytle,
          ),
          getSpacer(height: 8),
          Text(
            "People are more likely to pray alogn with you if you add a picture",
            style: bodySytle,
          ),
          getSpacer(height: 8),
          getSeparator,
          getSpacer(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _openCameraOrGallery(isCam: true);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: imageSize,
                  width: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                  ),
                  child: _image == null
                      ? Icon(
                          Icons.camera,
                          size: 60,
                        )
                      : ClipOval(
                          child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                          height: imageSize,
                          width: imageSize,
                        )),
                ),
              ),
              getSpacer(width: 8),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _openCameraOrGallery(isCam: false);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 1.5, color: Colors.red)),
                      child: Text(
                        "Select a File",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Size limit is 5 MB",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              )
            ],
          ),
          getSpacer(height: 8),
          getAppThemedChipButton(
              onpress: () {
                onPhotoSUbmit();
              },
              title: "Submit"),
        ],
      ),
    );
  }

  get getDobDialog {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Add your age",
            style: headerSytle,
          ),
          getSpacer(height: 8),
          Text(
            "It helps us to match you with the peple around the same age",
            style: bodySytle,
          ),
          getSpacer(height: 8),
          getSeparator,
          getSpacer(height: 8),
          Theme(
            data: ThemeData(
              accentColor: AppColors.lightBGColor,
              primaryColor: AppColors.primaryColor,
              primarySwatch: AppColors.buttonTextColor,
            ),
            child: Builder(
                builder: (context) => InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 1.5, color: Colors.red)),
                        child: Text(
                          //todo view date
                          _dob == null
                              ? "DD/MM/YY"
                              : getFormattedDateString(dateTime: _dob),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      onTap: () async {
                        DateTime _pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1600),
                          lastDate: DateTime.now(),
                        );

                        if (_pickedDate != null) {
                          setState(() {
                            _dob = _pickedDate;
                          });
                        }
                      },
                    )),
          ),
          getSpacer(height: 8),
          Row(
            children: <Widget>[
              Checkbox(
                value: _selectedCheckBox,
                activeColor: AppColors.primaryColor,
                onChanged: (x) {
                  setState(() {
                    _selectedCheckBox = !_selectedCheckBox;
                  });
                },
              ),
              Text("Don't show my age in my profile"),
            ],
          ),

//          Row(
//            children: <Widget>[
//              RadioListTile(
//                title: Text("Don't show age in my profile"),
//              )
//            ],
//          ),

          getAppThemedChipButton(
              onpress: () {
                onAgeSubmit();
              },
              title: "Submit"),
        ],
      ),
    );
  }

  get getAboutDialog {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "About you",
            style: headerSytle,
          ),
          getSpacer(height: 8),
          Text(
            "People like a strory write few lines about yourself",
            style: bodySytle,
          ),
          getSeparator,
          CupertinoTextField(
            controller: _aboutController,
            maxLines: 3,
            placeholder: "50 year old father of 3",
            maxLength: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryColor,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          getSpacer(height: 8),
          getAppThemedChipButton(
              onpress: () {
                onAboutSubmit();
              },
              title: "Submit"),
        ],
      ),
    );
  }

  get getPhoneDialog {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Contact",
            style: headerSytle,
          ),
          getSpacer(height: 8),
          Text(
            "Please add phone number",
            style: bodySytle,
          ),
          getSeparator,
          CupertinoTextField(
            controller: _phoneController,
//            maxLines: 3,
            placeholder: "Phone number",
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            maxLength: 16,
            keyboardType: TextInputType.number,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryColor,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          getSpacer(height: 8),
          getAppThemedChipButton(
              onpress: () {
                onPhoneSubmit();
              },
              title: "Submit"),
        ],
      ),
    );
  }

  get getPushDialog {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            AssetStrings.alarm,
            width: 100,
            height: 100,
          ),
          getSpacer(height: 8),
          Text(
            "Would you like to be reminded to pray everyday at 1:20 pm?",
            style: bodySytle,
            textAlign: TextAlign.center,
          ),
          getSeparator,
          getSpacer(height: 8),
          getAppThemedChipButton(
              onpress: () {
                onRemiderSubmit();
              },
              title: "Set up remider"),
          getSpacer(height: 20),
          InkWell(
            child: Text(
              "No I don't want a reminder",
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  get getCompleteDialog {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Well done!",
            style: headerSytle,
          ),
          getSpacer(height: 8),
          Text(
            "Well done you have earned a badge for completing your profile",
            style: bodySytle,
          ),
          getSeparator,
          Icon(
            Icons.android,
            size: 60,
          ),
          getSpacer(height: 8),
          InkWell(
            onTap: () {
              Navigator.pop(context, ProfileStatus.Completed);
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.primaryColor,
                ),
                child: Text(
                  "Owesome! display it on my profile",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(backgroundColor: Colors.transparent, child: getDialog());
  }

  Widget getDialog() {
    Widget dialog;
    switch (widget.step) {
      case NextStep.gender:
        dialog = getGenderDialog;
        break;
      case NextStep.picture:
        dialog = getImageDialog;
        break;
      case NextStep.dob:
        dialog = getDobDialog;
        break;
      case NextStep.about:
        dialog = getAboutDialog;
        break;
      case NextStep.phone:
        dialog = getPhoneDialog;
        break;
      case NextStep.push:
        dialog = getPushDialog;
        break;
      case NextStep.complete:
        dialog = Container();
        break;
    }
    return dialog;
  }

  _selectGender(value) {
    setState(() {
      _gender = value;
    });
  }

  _buildChooseFrom(dialogContext) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Divider(
          height: 10,
          thickness: 2,
          color: AppColors.primaryColor,
        ),
        ListTile(
          leading: Icon(Icons.camera, color: AppColors.primaryColor),
          title: Text("Take Photo"),
          onTap: () {
            Navigator.of(dialogContext).pop();
            _openCameraOrGallery(isCam: true);
          },
        ),
        ListTile(
          leading: Icon(Icons.image, color: AppColors.primaryColor),
          title: Text("Choose Photo"),
          onTap: () {
            Navigator.of(dialogContext).pop();
            _openCameraOrGallery(isCam: false);
          },
        ),
      ],
    );
  }

//image selection and upload methods
  _openCameraOrGallery({@required isCam}) async {
    print("was here");
    try {
      var image = await ImagePicker.pickImage(
        source: isCam ? ImageSource.camera : ImageSource.gallery,
imageQuality: 50,
       maxHeight: 500,
       maxWidth: 500
      );
      if (image != null) {
        _image = image;
        setState(() {});
      }
    } catch (e) {
      print("Exception:: $e");
    }
  }

  onGenderSubmit() {
    request.gender = getGenderValue(_gender);
    request.currentStep = NextStep.gender;
    Navigator.pop(context, request);
  }

  onPhotoSUbmit() {
    request.file = _image;
    request.currentStep = NextStep.picture;
    Navigator.pop(context, request);
  }

  onAgeSubmit() {
    request.dob = _dob?.millisecondsSinceEpoch ~/ 1000.toInt();
    request.currentStep = NextStep.dob;
    Navigator.pop(context, request);
//    Navigator.pop(context, ProfileStatus.age);
  }

  onAboutSubmit() {
    request.bio = _aboutController?.text ?? "";
    request.currentStep = NextStep.about;
    Navigator.pop(context, request);
//    Navigator.pop(context, ProfileStatus.about);
  }

  onPhoneSubmit() {
    request.phone = _phoneController?.text ?? "";
    request.currentStep = NextStep.phone;
    Navigator.pop(context, request);
//    Navigator.pop(context, ProfileStatus.about);
  }

  onRemiderSubmit() async{
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    String token =await _firebaseMessaging.getToken()??"";
    print("token ${token}");
    request.token = token;
    request.currentStep = NextStep.push;
    Navigator.pop(context, request);
//    Navigator.pop(context, ProfileStatus.about);
  }

  getGenderValue(gender value) {
    String res = "";
    switch (value) {
      case gender.male:
        res = "male";
        break;
      case gender.female:
        res = "female";
        break;
      case gender.undefined:
        res = "nonConforming";
        break;
    }
    return res;
  }
}
