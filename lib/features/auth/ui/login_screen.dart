import 'dart:convert';
import 'package:army120/features/auth/data/model/user.dart';
import 'package:army120/features/auth/data/model/login_request.dart';
import 'package:army120/features/auth/data/model/login_response.dart';
import 'package:army120/features/dashboard/Dashboard.dart';
import 'package:army120/features/auth/ui/forgot_password.dart';
import 'package:army120/features/auth/bloc/auth_bloc.dart';
import 'package:army120/features/auth/bloc/auth_events.dart';
import 'package:army120/features/auth/bloc/auth_state.dart';
import 'package:army120/features/auth/ui/signup_screen.dart';
import 'package:army120/network/api_handler.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/ValidatorFunctions.dart';
import 'package:army120/utils/app_theme/app_colors.dart';
import 'package:army120/utils/memory_management.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/reusableWidgets/header_widget.dart';
import 'package:army120/utils/singleton/Loggedin_user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:army120/features/auth/data/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Props
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();

  bool _showPassword = true;
  AuthBloc _lgoinBloc;
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();

  // Getters

  //return header
  get getHeader {
    return HeaderWidget(
      needBackButton: false,
    );
  }

  //return welcome text
  get getWelcomeText {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Welcome Back!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        getSpacer(height: getScreenSize(context: context).height * 0.02),
        Text(
          "Sign in to pray along your friends and family",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  //get form
  get getSignUpForm {
    double height = getScreenSize(context: context).height;
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          appThemedTextFieldTwo(
              label: "Email",
              controller: _emailController,
              context: context,
              focusNode: _emailFocus,
              validator: (String text) {
                return emailValidator(email:  text);
              },
              onFieldSubmitted: (str) {
                setFocusNode(context: context, focusNode: _passwordFocus);
              }),
          getSpacer(height: height * 0.01),
          appThemedTextFieldTwo(
              obscureText: _showPassword,
              label: "Password",
              controller: _passwordController,
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
              context: context,
              focusNode: _passwordFocus,
              onFieldSubmitted: (str) {
                closeKeyboard(context: context, onClose: () {});
              }),
          getSpacer(height: height * 0.03),
          InkWell(
            child: Text("Forgot Password ?",
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: 16)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BlocProvider(
                  create: (context) => AuthBloc(repository: AuthRepository()),
                  child: ForgotPasswordScreen(),
                ); //todo
              }));
            },
          ),
          getSpacer(height: height * 0.03),
//          OutlineButton(onPressed: (){},
//            child: Text("Sign in"),
//            color: AppColors.primaryColor,
//            disabledBorderColor: AppColors.primaryColor,
//            borderSide: BorderSide(
//
//              color: AppColors.primaryColor,
//
//            ),
//          ),
          Row(
            children: [
              getAppThemedButton(
                  title: "Sign in",
                  horizontalPadding:
                      getScreenSize(context: context).width * 0.2,
                  onpress: () async {
                    if (_loginFormKey.currentState.validate()) {
                      LoginRequest request = LoginRequest(
                        userName: _emailController.text,
                        password: _passwordController.text,
                      );

                      _lgoinBloc.add(DoLogin(loginRequest: request));
                    }
                  }),
              getSpacer(width: height * 0.02),
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
        color: Colors.black,
        fontSize: 14);
    var normalStyle = TextStyle(color: Colors.black);
    return Align(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: "Become a part of  Army? ",
              style: normalStyle,
            ),
            TextSpan(
              text: "Register",
              style: underlineStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BlocProvider(
                      create: (context) =>
                          AuthBloc(repository: AuthRepository()),
                      child: SignupScreen(),
                    );
                  }));
                },
            ),
          ],
        ),
      ),
    );
  } //get

  get getTerms {
    var underlineStyle = TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.black,
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
              },
          ),
          TextSpan(text: ' & ', style: normalStyle),
          TextSpan(
            text: "privacy policy",
            style: underlineStyle,
            recognizer: TapGestureRecognizer()..onTap = () {},
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

  // State methods
  @override
  Widget build(BuildContext context) {
    _lgoinBloc = BlocProvider.of<AuthBloc>(context);
    double height = getScreenSize(context: context).height;
    return GestureDetector(
      onTap: () {
        closeKeyboard(context: context, onClose: () {});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      getHeader,
                      getWelcomeText,
                      getSpacer(height: height * 0.06),
                      getSignUpForm,
                      getSpacer(height: height * 0.04),
//                    facebookButton,
                      getSpacer(height: height * 0.2),
                      getLoginSwitch,
                    ],
                  ),
                ),
                Offstage(
                  offstage: state is! LoginProcessingState,
                  child: CustomLoader(isTransparent: false),
                ),
                BlocListener<AuthBloc, AuthState>(
                    child: Container(
                      height: 0,
                      width: 0,
                    ),
                    listener: (context, state) async {
                      if (state is AuthErrorState) {
                        showAlert(
                            context: context,
                            titleText: "Error",
                            message: state?.message ?? "",
                            actionCallbacks: {"Ok": () {}});
                      }

                      if (state is LoginSuccessState) {
                        await onLoginSuccess(response: state.loginResponse);
                      }
                    })
              ],
            );
          },
        ),
      ),
    );
  }

  // on login success
  onLoginSuccess({LoginResponse response}) async {
    await setData(response?.data);
    try {
      await RestClient().create();
    } catch (e, st) {
      print("e----> $e, \n$st");
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Dashboard();
    }), (Route<dynamic> route) => false);
  }

  //set Logged in Data
  setData(User response) async {
    LoggedInUser.setUser = response;
    MemoryManagement.setUserInfo(userInfo: jsonEncode(response));
    MemoryManagement.setIsUserLoggedIn(isUserLoggedin: true);
    MemoryManagement.setAccessToken(accessToken: response?.token ?? "");
  }

  onSkip() async {
    await MemoryManagement.setIsSkipped(isUserLoggedin: true);

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Dashboard();
    }), (Route<dynamic> route) => false);
  }
}
