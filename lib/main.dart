import 'package:army120/utils/navigation/custom_navigation.dart';
import 'package:army120/utils/navigation/route_generator.dart';
import 'package:army120/utils/reusableWidgets/prayingHandAnimation.dart';
import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
import 'utils/app_theme/appTheme.dart';
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home:MyApp() ,));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: NavigationService().navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: MainRoute?.generateRoute,
      title: '120 Army',
      theme: AppTheme.appTheme,
      home: SafeArea(child:SplashScreen()
      )// SplashScreen()),
    );
  }
}
