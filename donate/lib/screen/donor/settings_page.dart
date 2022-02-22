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
import 'package:shared_preferences/shared_preferences.dart';

import '../../wrapper.dart';
/**
 * SettingsPage class with notificaition, language choice
 */

/// Author: Joyshree Chowdhury
/// All rights reserved

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  bool notiState = false;
  bool infoState = true;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    _getStateNotification();

    super.initState();
  }

  _getStateNotification() async {
    final SharedPreferences prefs = await _prefs;
    notiState = prefs.getBool('notification');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, '');
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text('settings').tr(),
        backgroundColor: Colors.red,
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 20, 20, 50),
        children: [
          ListTile(
            title: Text('get notifications').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(LineIcons.bell, size: 22, color: Colors.white),
            ),
            trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                value: notiState,
                onChanged: (value) async {
                  // context.read<NotificationBloc>().fcmSubscribe(bool);
                  final SharedPreferences prefs = await _prefs;
                  prefs.setBool('notification', value);

                  setState(() {
                    notiState = value;
                  });
                }),
          ),
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

  // Show alert dialog to logout account
  showLogoutAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('confirm logout').tr(),
            content: Text('are you sure want to logout?').tr(),
            actions: [
              TextButton(
                child: Text('no').tr(),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                  child: Text('yes').tr(),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  }
                //nextScreenReplace(context, Wrapper());},
              ),
            ],
          );
        });
  }
}
