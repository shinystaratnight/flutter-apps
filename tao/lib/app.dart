import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tao/bloc/sign_in_bloc.dart';
import 'package:tao/bloc/theme_bloc.dart';
import 'package:tao/pages/splash.dart';

import 'models/theme_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: Consumer<ThemeBloc>(
        builder: (_, mode, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<SignInBloc>(
                create: (context) => SignInBloc(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              supportedLocales: context.supportedLocales,
              theme: ThemeModal().lightMode,
              home: const SplashPage(),
            ),
          );
        },
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   supportedLocales: context.supportedLocales,
    //   theme: ThemeModal().lightMode,
    //   home: const SplashPage(),
    // );
  }
}
