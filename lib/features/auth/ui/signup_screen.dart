import 'dart:convert';
import 'package:army120/features/auth/data/auth_repository.dart';
import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/auth/bloc/auth_events.dart';
import 'package:army120/features/auth/bloc/auth_state.dart';
import 'package:army120/features/auth/ui/login_screen.dart';
import 'package:army120/features/dashboard/Dashboard.dart';
import 'package:army120/features/auth/bloc/auth_bloc.dart';
import 'package:army120/features/auth/data/model/signUpResponse.dart';
import 'package:army120/features/auth/data/model/signup_request.dart';
import 'package:army120/network/api_urls.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/ValidatorFunctions.dart';
import 'package:army120/utils/memory_management.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/reusableWidgets/header_widget.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';


class SignupScreen extends StatefulWidget {
  final bool isDirect;

  SignupScreen({this.isDirect: false});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Props
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _fullNameFocusNode = new FocusNode();
  FocusNode _userNameFocusNode = new FocusNode();
  FocusNode _passwordNameFocusNode = new FocusNode();
  bool _showPassword = false;

  AuthBloc signUpBloc;

  final GlobalKey<FormState> _signupFormKey = new GlobalKey<FormState>();

  // Getters

  //return header
  get getHeader {
    return HeaderWidget(
      needBackButton: true,
    );
  }

  //return welcome text
  get getWelcomeText {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Welcome!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        getSpacer(height: getScreenSize(context: context).height * 0.02),
        Text(
          "Create your account to begin your prayer journey with your friends and family",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  //get form
  get getSignUpForm {
    double height = getScreenSize(context: context).height;
    return Form(
      key: _signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          appThemedTextFieldTwo(
              label: "Email",
              controller: _emailController,
              context: context,
              focusNode: _emailFocusNode,
              validator: (String text) {
                return emailValidator(email: text);
              },
              onFieldSubmitted: (str) {
                setFocusNode(context: context, focusNode: _fullNameFocusNode);
              }),
          appThemedTextFieldTwo(
              label: "Full name",
              controller: _fullNameController,
              context: context,
              focusNode: _fullNameFocusNode,
              validator: (String text) {
                return nameValidator(name: text);
              },
              onFieldSubmitted: (str) {
                setFocusNode(context: context, focusNode: _userNameFocusNode);
              }),
          appThemedTextFieldTwo(
              label: "Username",
              controller: _usernameController,
              context: context,
              focusNode: _userNameFocusNode,
              validator: (String text) {
                return userNameValidator(userName: text);
              },
              onFieldSubmitted: (str) {
                setFocusNode(
                    context: context, focusNode: _passwordNameFocusNode);
              }),
          appThemedTextFieldTwo(
              label: "Password",
              controller: _passwordController,
              context: context,
              focusNode: _passwordNameFocusNode,
              obscureText: _showPassword,
              validator: (String text) {
                return enteredPasswordValidator(enteredPassword: text);
              },
              suffixWidget: new Icon(
                _showPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPrefixOneTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              onFieldSubmitted: (x) {
                closeKeyboard(context: context, onClose: () {});
              }),
          getSpacer(height: height * 0.04),
          Row(
            children: [
              getAppThemedButton(
                  horizontalPadding:
                      getScreenSize(context: context).width * 0.2,
                  title: "Sign up",
                  onpress: () {
                    if (_signupFormKey.currentState.validate()) {
                      SignUpRequest request = SignUpRequest(
                        password: _passwordController.text,
                        email: _emailController.text,
                        username: _usernameController.text,
                        fullName: _fullNameController.text,
                      );

                      signUpBloc.add(DoSignUp(request: request));
                    }

//                Navigator.push(context, MaterialPageRoute(builder: (context) {
//                  return LoginScreen();
//
//
//                }));
                  }),
              SizedBox(
                width: 10,
              ),
              InkWell(
                child: Text("Skip",
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 16)),
                onTap: () {
                  onSkip();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  //get
  get getLoginSwitch {
    var underlineStyle = TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.red,
        fontSize: 14,
        fontWeight: FontWeight.bold);
    var normalStyle = TextStyle(color: Colors.black);

    return RichText(
      // textAlign: TextAlign.center,

      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "Already part to 120 Army? ",
            style: normalStyle,
          ),
          TextSpan(
            text: "Sign in",
            style: underlineStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Navigator.pop(context);
                if (widget.isDirect) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return BlocProvider(
                      create: (context) =>
                          AuthBloc(repository: AuthRepository()),
                      child: LoginScreen(),
                    ); //
                  }));
                } else {
                  Navigator.pop(context);
                }
              },
          ),
        ],
      ),
    );
  } //get

  get getTerms {
    var underlineStyle = TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 14);
    var normalStyle = TextStyle(color: Colors.black);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "By signing up you are agree to our ",
            style: normalStyle,
          ),
          TextSpan(
            text: "Terms ",
            style: underlineStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print("todo");
                openTerms();
              },
          ),
          TextSpan(text: ' & ', style: normalStyle),
          TextSpan(
            text: "privacy policy",
            style: underlineStyle,
            recognizer: TapGestureRecognizer()..onTap = () {
              openPrivacy();
            },
          ),
        ],
      ),
    );
  }

  get facebookButton {
    return Row(
      children: <Widget>[
        Text("Or sign in with facebook"),
        getSpacer(width: 10),
        Icon(Icons.android)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    signUpBloc = BlocProvider.of<AuthBloc>(context);
    double height = getScreenSize(context: context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthBloc, AuthState>(
//        bloc: SignUpBloc() ,
          builder: (context, state) {
        print("State ${state}");
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getHeader,
                  getWelcomeText,
                  getSpacer(height: height * 0.03),
                  getSignUpForm,
//                  getSpacer(height: height * 0.07),
//                  facebookButton,
                  getSpacer(height: height * 0.05),
                  getLoginSwitch,
                  getSpacer(height: height * 0.05),
                  getTerms,
                  getSpacer(height: height * 0.05),
                ],
              ),
            ),
            Offstage(
              offstage: state is! SignUpProcessingState,
              child: CustomLoader(isTransparent: false),
            ),
            BlocListener<AuthBloc, AuthState>(
//                  bloc: blocA,
                child: Container(
                  height: 0,
                  width: 0,
                ),
                listener: (context, state) async {
                  if (state is AuthErrorState) {
                    print("Erorr");
                    showAlert(
                        context: context,
                        titleText: "Error",
                        message: state?.message ?? "",
                        actionCallbacks: {"Ok": () {}});
                  }

                  if (state is SignUpSuccessState) {
                    await onLoginSucess(response: state?.response);
                  }
                })
          ],
        );
      }),
    );
  }

  //On Login Success
  onLoginSucess({SignUpResponse response}) async {
    await setData(response?.data);
    await showAlert(
        context: context,
        titleText: "Success",
        message: response?.message ?? "",
        actionCallbacks: {
          "Ok": () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return Dashboard();
            }), (Route<dynamic> route) => false);
          }
        });
  }

  //set Logged in Data
  setData(User response) async {
    LoggedInUser.setUser = response;
    MemoryManagement.setUserInfo(userInfo: jsonEncode(response));
    MemoryManagement.setIsUserLoggedIn(isUserLoggedin: true);
    MemoryManagement.setAccessToken(accessToken: response?.token ?? "");
  }

  onSkip() async{
    await MemoryManagement.setIsSkipped(isUserLoggedin: true);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Dashboard();
    }), (Route<dynamic> route) => false);
  }

  void openTerms()async {
    if (await canLaunch(ApiURL.termsAndCondition)) {
    await launch(ApiURL.termsAndCondition, forceSafariVC: false);
    } else {
    throw 'Could not launch $ApiURL.privacyURL';
    }
  }

  void openPrivacy() async{
    if (await canLaunch(ApiURL.privacyURL)) {
    await launch(ApiURL.privacyURL, forceSafariVC: false);
    } else {
    throw 'Could not launch $ApiURL.privacyURL';
    }
  }
}
