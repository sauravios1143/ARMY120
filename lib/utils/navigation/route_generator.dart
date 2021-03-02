import 'package:army120/features/auth/bloc/auth_bloc.dart';
import 'package:army120/features/auth/data/auth_repository.dart';
import 'package:army120/features/auth/ui/login_screen.dart';
import 'package:army120/features/dashboard/Dashboard.dart';
import 'package:army120/features/splash/splash_screen.dart';
import 'package:army120/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainRoute{
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case AppRoutes?.login:
        return MaterialPageRoute(builder: (_) => BlocProvider(
          create: (BuildContext context)=>AuthBloc(
            repository: AuthRepository()
          ),
            child: LoginScreen()));
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => Dashboard());
        case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());


      default:
        return null;
    }
  }
}