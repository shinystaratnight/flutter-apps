import 'package:flutter/material.dart';
import 'package:fluttertest/authenticate/DonorOrOrg.dart';

import 'sign_in.dart';
import 'donorRegister.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String registerWith;
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return DonorOrOrg(
        toggleView: toggleView,
        registerWith: registerWith,
      );
    }
  }
}
