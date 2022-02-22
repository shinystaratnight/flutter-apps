import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/authenticate/sign_in.dart';
import 'package:fluttertest/screen/user/profile.dart';

import 'package:provider/provider.dart';

import '../../services/auth.dart';
import 'beneficiaries.dart';
import 'donors.dart';
import 'events.dart';
import 'package:fluttertest/screen/user/adminHome.dart';
import 'adminHome.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final AuthService _auth = AuthService();

  @override
  //BUILD METHOD
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Donaid'),
      //   backgroundColor: Colors.red,
      //   actions: [
      //     FlatButton.icon(
      //         onPressed: () async {
      //           await _auth.signOut();
      //           Navigator.popUntil(context, ModalRoute.withName("/"));
      //         },
      //         icon: Icon(Icons.person),
      //         label: Text('Sign out'))
      //   ],
      // ),
      body: AdminHome('2'),
      // const Center(
      //   child: Text('My Page!'),
      // ),
      // drawer: const OrganizationDrawer());
    );
  }
}

//Organization Drawer for page to page navigation
class OrganizationDrawer extends StatefulWidget {
  const OrganizationDrawer({Key key}) : super(key: key);

  @override
  _OrganizationDrawerState createState() => _OrganizationDrawerState();
}

class _OrganizationDrawerState extends State<OrganizationDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Center(
                child: Text('Donaid'),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserHome()),
                );
              },
            ),
            ListTile(
              title: const Text('Events'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrganizationEvents()),
                );
              },
            ),
            ListTile(
              title: const Text('Categories'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  OrganizationDonors()),
                );
              },
            ),
            ListTile(
              title: const Text('Beneficiaries'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrganizationBeneficiaries()),
                );
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrganizationProfile()),
                );
              },
            ),
            // ListTile(
            //   title: const Text('Create Events'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => CreateEvents()),
            //     );
            //   },
            // ),
            ListTile(
              title: const Text('...'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
