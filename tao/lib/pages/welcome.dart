import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:tao/bloc/sign_in_bloc.dart';
import 'package:tao/config/config.dart';
import 'package:tao/pages/home.dart';
import 'package:tao/services/app_service.dart';
import 'package:tao/utils/app_name.dart';
import 'package:tao/utils/next_screen.dart';
import 'package:tao/utils/snacbar.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _googleController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _facebookController =
      new RoundedLoadingButtonController();

  handleGoogleSignIn() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(scaffoldKey, 'Check your internet connection!'.tr());
      } else {
        await sb.signInWithGoogle().then((_) {
          if (sb.hasError == true) {
            openSnacbar(
                scaffoldKey, 'something is wrong. please try again.'.tr());
            _googleController.reset();
          } else {
            handleAfterSignIn();
          }
        });
      }
    });
  }

  handleFacebbokLogin() {
    handleAfterSignIn();
  }

  handleAfterSignIn() {
    setState(() {
      Future.delayed(Duration(milliseconds: 1000)).then((f) {
        gotoNextScreen();
      });
    });
  }

  gotoNextScreen() {
    nextScreenReplace(context, HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32.0),
                    child: Image(
                      image: AssetImage(Config().splashIcon),
                      height: 150,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome to',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context).secondaryHeaderColor),
                          ).tr(),
                          SizedBox(
                            width: 10,
                          ),
                          AppName(fontSize: 25),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 5),
                        child: Text(
                          'Sign in to continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).secondaryHeaderColor),
                        ).tr(),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedLoadingButton(
                    child: Wrap(
                      children: [
                        Icon(
                          FontAwesome.google,
                          size: 25,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Sign In with Google',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    ),
                    controller: _googleController,
                    onPressed: () => handleGoogleSignIn(),
                    width: MediaQuery.of(context).size.width * 0.80,
                    color: Colors.blueAccent,
                    elevation: 0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RoundedLoadingButton(
                    child: Wrap(
                      children: [
                        Icon(
                          FontAwesome.facebook,
                          size: 25,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Sign In with Facebook',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    controller: _facebookController,
                    onPressed: () => handleFacebbokLogin(),
                    width: MediaQuery.of(context).size.width * 0.80,
                    color: Colors.indigo,
                    elevation: 0,
                    //borderRadius: 3,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Text("Don't have social accounts?").tr(),
            TextButton(
              child: Text(
                'Continue with phone >>',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ).tr(),
              onPressed: () {
                // if(widget.tag == null){
                //   nextScreen(context, SignUpPage());

                // }else{
                //   nextScreen(context, SignUpPage(tag: 'Popup',));
                // }
              },
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
