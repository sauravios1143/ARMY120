import 'package:army120/features/auth/bloc/auth_bloc.dart';
import 'package:army120/features/auth/bloc/auth_events.dart';
import 'package:army120/features/auth/bloc/auth_state.dart';
import 'package:army120/features/auth/data/auth_repository.dart';
import 'package:army120/features/auth/data/model/forgot_password_request.dart';
import 'package:army120/features/auth/ui/resetPassword%20screen.dart';
import 'package:army120/utils/ReusableWidgets.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/ValidatorFunctions.dart';
import 'package:army120/utils/reusableWidgets/custom_loader.dart';
import 'package:army120/utils/reusableWidgets/header_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //props
  TextEditingController _emailController = new TextEditingController();
  FocusNode _emailFocus = FocusNode();
  AuthBloc _authBloc;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  //getters

  //return header
  get getHeader {
    return HeaderWidget();
  }

  //return welcome text
  get getWelcomeText {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Forgot Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        getSpacer(height: getScreenSize(context: context).height * 0.03),
        Text(
          "Enter your email and we'll send you reset email to sign in",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  //get form
  get getSignUpForm {
    double height = getScreenSize(context: context).height;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          appThemedTextFieldTwo(label: "email address", controller: _emailController,
          appThemedTextFieldTwo(
              label: "Email",
              controller: _emailController,
              context: context,
              focusNode: _emailFocus,
              validator: (String text) {
                return emailValidator(email: text);
              },
              onFieldSubmitted: (str) {
                closeKeyboard(context: context, onClose: () {});
              }),

          getSpacer(height: height * 0.1),
          getAppThemedButton(
              horizontalPadding: getScreenSize(context: context).width * 0.15,
              title: "Send email",
              onpress: () {
                if (formKey.currentState.validate()) {
                  forgotPassord();
                }
              }),
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
    return RichText(
      textAlign: TextAlign.center,
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
                print("todo");
              },
          ),
        ],
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

  //state methods
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_authBloc == null) {
      _authBloc = BlocProvider.of<AuthBloc>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard(context: context, onClose: () {});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            getPage,
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Offstage(
                  offstage: !(state is LoginProcessingState),
                  child: CustomLoader(isTransparent: false),
                );
              },
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

                  if (state is ForgotPwdSuccessState) {
                    showAlert(
                        context: context,
                        titleText: "Success",
                        message:
                            "Reset password link has sent to your email address",
                        actionCallbacks: {
                          "Ok": () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BlocProvider(
                                  create: (context) =>
                                      AuthBloc(repository: AuthRepository()),
                                  child: ResetPasswordScreen(
                                    email: _emailController?.text,
                                  ));
                            }));
                          }
                        });
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget get getPage {
    double height = getScreenSize(context: context).height;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: <Widget>[
          getHeader,
          getWelcomeText,
          getSpacer(height: height * 0.06),
          getSignUpForm,
          getSpacer(height: height * 0.15),
//
//            getLoginSwitch,
//            getSpacer(height: height*0.03),
//
//            getTerms
        ],
      ),
    );
  }

  forgotPassord() {
    _authBloc.add(ForgotPasswordEvent(
        request: ForgotPasswordRequest(
      email: _emailController.text,
      kind: "forgotpass",
    )));
  }
}
