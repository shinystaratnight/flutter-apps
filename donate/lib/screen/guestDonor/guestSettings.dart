// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/authenticate/authenticate.dart';
import 'package:fluttertest/authenticate/sign_in.dart';
import 'package:fluttertest/screen/donor/next_screen.dart';
import 'package:fluttertest/screen/donor/language.dart';
import 'package:fluttertest/services/auth.dart';
import 'package:line_icons/line_icons.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

import '../../wrapper.dart';
/**
 * SettingsPage class with notificaition, language choice and logout options
 */

class GuestSettingsPage extends StatefulWidget {
  const GuestSettingsPage({Key key}) : super(key: key);

  @override
  _GuestSettingsPageState createState() => _GuestSettingsPageState();
}

class _GuestSettingsPageState extends State<GuestSettingsPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  bool notiState = false;
  bool infoState = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('settings').tr(),
        backgroundColor: Colors.red,
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 20, 20, 50),
        children: [
          Divider(
            height: 3,
          ),
          ListTile(
            title: Text('language').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(FeatherIcons.globe, size: 20, color: Colors.white),
            ),
            trailing: Icon(
              FeatherIcons.chevronRight,
              size: 20,
            ),
            onTap: () {
              nextScreen(context, LanguagePopup());
            },
            // onTap: () => nextScreenPopup(context, LanguagePopup()),
          ),
          Divider(
            height: 3,
          ),
        ],
      ),
    );
  }
}
