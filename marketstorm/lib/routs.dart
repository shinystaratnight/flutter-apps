import 'package:flutter/widgets.dart';
import 'package:marketstorm/screens/forgot_password/forgot_password.dart';
import 'package:marketstorm/screens/sign_in/sign_in_screen.dart';
import 'package:marketstorm/screens/sign_up/sign_up_screen.dart';
import 'package:marketstorm/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.rountName: (context) => SignUpScreen(),
};
