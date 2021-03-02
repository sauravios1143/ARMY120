import 'dart:io';
import 'package:army120/features/profile/bloc/profile_bloc.dart';
import 'package:army120/features/profile/bloc/profile_events.dart';
import 'package:army120/features/profile/bloc/profile_state.dart';
import 'package:army120/features/profile/data/model/update_profile_request.dart';
import 'package:army120/utils/Constants/profileConstant.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/reusableWidgets/imageSelector.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //Props
  TextEditingController nameController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode userNameFocusNode = FocusNode();
  FocusNode bioFocusNode = FocusNode();
  gender _selectedGender;

  TextEditingController emailController = new TextEditingController();
  // TextEditingController genderController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode genderNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  bool showLoader = false;
  ProfileBloc profileBloc;
  File selectedProfile;
  bool isUpdated=false;

  //Getters
  Widget get geProfilePhoto {
    return ImageSelector(
      height: getScreenSize(context: context).width * 0.4,
      width: getScreenSize(context: context).width * 0.4,
      hideEditButton: false,
      onSelect: (file) {
        selectedProfile = file;
      },
      defalutImage: LoggedInUser?.userDetail?.profilePicture?.thumbnailUrl,
    );
  }

  Widget get getBasiceDetail {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 1, child: getHeader("Name")),
            Expanded(
              flex: 3,
              child: appThemedTextField(
                controller: nameController,
                focusNode: nameFocusNode,
                context: context,
                hint: "Name",
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 1, child: getHeader("Username")),
            Expanded(
              flex: 3,
              child: appThemedTextField(
                enabled: false,
                controller: userNameController,
                focusNode: userNameFocusNode,
                context: context,
                hint: "Username",
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 1, child: getHeader("Bio")),
            Expanded(
              flex: 3,
              child: appThemedTextField(
                controller: bioController,
                focusNode: bioFocusNode,
                context: context,
                maxLines: 2,
                hint: "Bio",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get getOtherDetail {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 1, child: getHeader("Email")),
            Expanded(
              flex: 3,
              child: appThemedTextField(
                enabled: false,

                controller: emailController,
                focusNode: emailFocusNode,
                context: context,
                hint: "",
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 1, child: getHeader("Phone")),
            Expanded(
              flex: 3,
              child: appThemedTextField(
                controller: phoneController,
                focusNode: phoneFocusNode,
                context: context,
                hint: "Phone Number",
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        /* Row(
          children: [
            Expanded(flex: 1, child: getHeader("Gender")),
            Expanded(
              flex: 3,
              child: appThemedTextField(
                controller: genderController,
                focusNode: genderNameFocusNode,
                context: context,
                label: "Gender",
              ),
            ),
          ],
        ),*/
        Row(
          children: [
            Expanded(flex: 1, child: getHeader("Gender")),
            Expanded(
              flex: 3,
              child: DropdownButton<gender>(

                value: _selectedGender,
                  // icon: Text("${getGenderValue(_selectedGender)}"),
                  items: [

                DropdownMenuItem(
                  child: Text("Male"),
                  onTap: (){
                    // changeGender(gender?.male);
                  },
                  value: gender.male,
                ), DropdownMenuItem(
                  child: Text("Female"),
                  onTap: (){
                    // changeGender(gender?.female);

                  },
                  value: gender.female,
                ), DropdownMenuItem(
                  child: Text("Undefined"),
                  onTap: (){
                    // changeGender(gender?.undefined);
                  },
                  value: gender.undefined,
                ),
              ], onChanged: (value){
                changeGender(value);
              })
            ),
          ],
        ),
      ],
    );
  }

  changeGender(gender gender ){
    print("changed ");
    _selectedGender = gender;
    setState(() {

    });
  }
  Widget get getPage {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        geProfilePhoto,
        getBasiceDetail,
        getTabHeader("Other Information"),
        getOtherDetail
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDefault();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (profileBloc == null) {
      profileBloc = BlocProvider.of<ProfileBloc>(context);
      fetchUserDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard(context: context, onClose: () {});
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: getAppThemedAppBar(context,
                titleText: "Edit Profile",
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: Align(
                      alignment: Alignment.center,

                      child: getAppThemedFilledButton(
                        onpress: (){},
                        title: "Save"
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     //todo
                      //     // findMinSort();
                      //     updateProfile();
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(right: 10),
                      //     padding:
                      //         EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(5),
                      //         border: Border.all(color: AppColors.primaryColor)),
                      //     child: Text(
                      //       "Save",
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //   ),
                      // ),
                    ),
                  )
                ]),
            body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: getPage),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Offstage(
                offstage: !(state is ProfileUpdatingState),
                child: CustomLoader(isTransparent: false),
              );
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
              child: Container(
                height: 0,
                width: 0,
              ),
              listener: (context, state) async {
                if (state is ProfileErrorState) {
                  showAlert(
                      context: context,
                      titleText: "Error",
                      message: state?.message ?? "",
                      actionCallbacks: {"Ok": () {}});
                }
                if (state is UpdateSuccessState) {
                  showAlert(
                      context: context,
                      titleText: "Success",
                      message: "Profile updated",
                      actionCallbacks: {"Ok": () {
                        Navigator.pop(context,1);//todo
                      }});
                }
              })
        ],
      ),
    );
  }

  Widget getHeader(String text) {
    return Text(
      text ?? "",
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }

  Widget getTabHeader(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Text(
        text ?? "",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  //upload file
  updateProfile() {
    UpdateProfileRequest request = UpdateProfileRequest();
    request.file = selectedProfile;
    request.name = nameController.text;
    request.userName = userNameController.text;
    request.bio = bioController.text;
    request.email = emailController.text;
    request.phone = phoneController.text;
    // request.gender = genderController.text;
   request.gender = getGenderValue(_selectedGender);
    profileBloc.add(UpdateUserDetail(
      updateProfileRequest: request,
    ));
  }

  setDefault() {
    nameController.text = LoggedInUser.getUserDetail?.firstName;
    userNameController.text = LoggedInUser.getUserDetail?.username;
    bioController.text = LoggedInUser.getUserDetail?.about;
    emailController.text = LoggedInUser.getUserDetail?.email;
    phoneController.text = LoggedInUser.getUserDetail?.phone;
    // genderController.text = LoggedInUser.getUserDetail?.gender;
    setGender(LoggedInUser.getUserDetail?.gender);
   }

  fetchUserDetail() {
    profileBloc.add(FetchUserDetail());
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
  setGender(String  value) {
    gender res ;
    switch (value) {
      case "male":
        res = gender.male;
        break;
        case "female":
        res = gender.female;
        break;
        case "nonConforming":
        res = gender.undefined;
        break;

    }
    _selectedGender=res;
  }
}
