import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart';

class Routes {
  static const String login = '/';
  static const String signup = '/signup';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginPage(),
      signup: (context) => SignupPage(),
      home: (context) => HomePage(),
    };
  }
}