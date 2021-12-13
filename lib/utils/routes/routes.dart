import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/ui/login/login.dart';
import 'package:boilerplate/ui/login/signup.dart';
import 'package:boilerplate/ui/my_voucher/my_voucher.dart';
import 'package:boilerplate/ui/request/request.dart';
import 'package:boilerplate/ui/splash/splash.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String request = "/request";
  static const String voucher = "/voucher";

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    signup: (BuildContext context) => SignupScreen(),
    home: (BuildContext context) => HomeScreen(),
    request: (BuildContext context) => RequestScreen(),
    voucher: (BuildContext context) => MyVoucherScreen()
  };
}
