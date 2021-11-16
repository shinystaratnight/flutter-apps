import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';
import 'package:tao/bloc/sign_in_bloc.dart';
import 'package:tao/config/config.dart';
import 'package:tao/pages/welcome.dart';
import 'package:tao/utils/next_screen.dart';

import 'home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  afterSplash() {
    final SignInBloc sb = context.read<SignInBloc>();
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      sb.isSignedIn == true
          ? nextScreenReplace(context, HomePage())
          : nextScreenReplace(context, WelcomePage());
    });
  }

  @override
  void initState() {
    afterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config().bgColor,
      body: Stack(
        children: [
          Image.asset(
            Config().splashIcon,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ],
      ),
    );
  }
}
