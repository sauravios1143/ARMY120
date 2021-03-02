import 'package:army120/features/auth/bloc/auth_events.dart';
import 'package:army120/features/auth/bloc/auth_state.dart';
import 'package:army120/features/auth/data/auth_repository.dart';
import 'package:army120/features/auth/data/model/login_response.dart';
import 'package:army120/features/auth/data/model/signUpResponse.dart';
import 'package:army120/utils/UniversalFunctions.dart';
import 'package:army120/utils/app_messages.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({this.repository});

  @override
  AuthState get initialState => LoginInitialState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is DoLogin) {
      yield LoginProcessingState();
      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield AuthErrorState(message: AppMessages.noInternet);
          return;
        }

        LoginResponse response =
            await repository.login(request: event?.loginRequest);
        yield LoginSuccessState(loginResponse: response);
      } catch (e) {
        print("Exception in login ${e}");
        yield AuthErrorState(message: e.toString());
      }
    }
    //Signup up
    if (event is DoSignUp) {
      yield SignUpProcessingState();

      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield AuthErrorState(message: AppMessages.noInternet);
          return;
        }
        SignUpResponse response =
            await repository.signUp(request: event?.request);
        yield SignUpSuccessState(response: response);
      } catch (e) {
        print("Exception in login ${e}");
        yield AuthErrorState(message: e.toString());
      }
    }   //Forgot password  up
    if (event is ForgotPasswordEvent) {
      yield LoginProcessingState();

      try {
        bool isConnected =
            await checkInternetForPostMethod(onSuccess: () {}, onFail: () {});
        if (!isConnected) {
          yield AuthErrorState(message: AppMessages.noInternet);
          return;
        }
        var response =
            await repository.forgotPwd(request:event?.request);
        yield ForgotPwdSuccessState();
      } catch (e) {
        print("Exception in login ${e}");
        yield AuthErrorState(message: e.toString());
      }
    }
  }
}
