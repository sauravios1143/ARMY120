import 'package:flutter/material.dart';

class NavigationService {


  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  static NavigationService _navigationService;
   NavigationService._privateConstructor(); //privateConstructor

  factory NavigationService() {
    //factory Constructor
    if (_navigationService == null) {
      _navigationService = NavigationService._privateConstructor();
      return _navigationService;
    }
    return _navigationService;
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
}