import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/donor/config.dart';
import 'package:fluttertest/screen/donor/donate.dart';
import 'package:fluttertest/screen/donor/edit_profile_page.dart';
import 'package:fluttertest/screen/donor/favorite_page.dart';
import 'package:fluttertest/screen/donor/my_donation_page.dart';
import 'package:fluttertest/screen/donor/organization_view_page.dart';
import 'package:fluttertest/screen/donor/settings_page.dart';
import 'package:fluttertest/screen/donor/next_screen.dart';
import 'package:fluttertest/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import 'donor_user_bloc.dart';

/// Menu for donor account
/// Menu items: home, favorite, edit profile, donations, settings, donate
/// Author: Joyshree Chowdhury
/// All rights reserved
class DrawerMenu extends StatelessWidget {
  DrawerMenu({Key key, this.onResult}) : super(key: key);

  ValueChanged onResult;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // Drawer menu item titles
    final List titles = [
      'home',
      'my favorite',
      'edit profile',
      'my donations',
      'settings',
      'logout',
    ];

    // Drawer menu item icons
    final List icons = [
      Icons.home_outlined,
      Icons.favorite_outline,
      Icons.people_outline,
      Icons.history_outlined,
      Icons.settings_outlined,
      Icons.logout_outlined,
    ];

    /**
     * Drawer widget
     * This is include header and body
     */
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DrawerHeader(
              // Header section
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Config().appName,
                        style: TextStyle(fontSize: 25.0),
                      ),
                      Text(
                        'Version: 1.0',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      )
                    ],
                  ),
                )),
            Container(
              // Body section(home, favorite, edit profile, my donations, settings) with ListView builder
              child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 30),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        titles[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ).tr(),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        child: Icon(
                          icons[index],
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        if (index == 0) {
                        } else if (index == 1) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavouritePage()),
                          );
                          onResult(result);
                          // nextScreen(context, FavouritePage());
                        } else if (index == 2) {
                          // Go to edit profile page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider<DonorUserBloc>(
                                          create: (context) => DonorUserBloc(),
                                        ),
                                      ],
                                      child: EditProfilePage(),
                                    )),
                          );
                        } else if (index == 3) {
                          // Go to my history page
                          nextScreen(context, MyDonationPage());
                        } else if (index == 4) {
                          // Go to setting page
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          );
                          onResult(result);
                          // nextScreen(context, SettingsPage());
                        } else {
                          showLogoutAlert(context);
                        }
                      },
                    );
                  },
                  separatorBuilder: (ctx, idx) => const Divider(
                    height: 0,
                  ),
                  itemCount: titles.length),
            )
          ],
        ),
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
