//import 'package:firebase/firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:fluttertest/provider/userTypeProvider.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import './shared/loading.dart';
import './services/auth.dart';
import 'wrapper.dart';

void main() async {
  Stripe.publishableKey =
  'pk_test_51JfdVZISnM4T1D6nBQkZALRXgXtvlZOfPML7jSYwhi3sCDjXrv2gonAG0gt2PyWa2EN8fLLWEXn5ujIy3D5hF6HF00GB59M49N';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /** Added EasyLocalization for multiple languages
   *  Edited by @JoyshreeChowdhury
   */

  runApp(EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
        Locale('ja')
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: Locale('en'),
      useOnlyLangCode: true,
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      // Changed GetMaterialApp to MaterialApp by Joyshree
        child: MaterialApp(
          /**Added following three lines for multiple language
           *  Edited by @Joyshree_Chowdhury
           *
           */
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          ////////////////////////////////////////////////////
          home: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error');
              } else if (snapshot.hasData) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: PUserType()),
                    StreamProvider<User>.value(
                      value: AuthService().user,
                      initialData: null,
                    ),
                  ],
                  child: Wrapper(),
                );
              } else {
                return Loading();
              }
            },
          ),
        ),
    );
  }
}
