import 'package:army120/features/auth/data/model/forgot_password_request.dart';
import 'package:army120/features/auth/data/model/login_request.dart';
import 'package:army120/features/auth/data/model/signup_request.dart';
import 'package:flutter/foundation.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class DoLogin extends AuthEvent {
  final LoginRequest loginRequest;

  const DoLogin({@required this.loginRequest});

  @override
  List<Object> get props => [loginRequest];
}

class DoSignUp extends AuthEvent {
  final SignUpRequest request;

  DoSignUp({this.request});
}

class ForgotPasswordEvent extends AuthEvent {
  ForgotPasswordRequest request;
  ForgotPasswordEvent({this.request});
}
