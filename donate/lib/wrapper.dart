import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/models/UserType.dart';
import 'package:fluttertest/provider/userTypeProvider.dart';
import 'package:fluttertest/screen/admin/wrapperAdminHome.dart';
import 'package:fluttertest/screen/user/wrapperUserHome.dart';
import 'package:fluttertest/services/auth.dart';
import 'package:fluttertest/shared/loading.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './authenticate/authenticate.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final pBatch = Provider.of<PUserType>(context, listen: false);
      pBatch.getUserType(context);
    });
  }

  void signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String userIs = '0';
    //final userT = Provider.of<QuerySnapshot>(context);
    final pUserType = Provider.of<PUserType>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      if (pUserType.loading == true) {
        return Loading();
      } else {
        for (var i in pUserType.lUserType) {
          print('i uid is ${i.uid}');
          if (i.uid == user.uid) {
            userIs = i.userType.toString();
          }
        }
        print('User $user');
        if (user.emailVerified) {
          print('This user email is verified');
          print(user.uid);
          if (userIs == '1') {
            return WrapperAdminHome(user.uid);
          } else if (userIs == '2') {
            return WrapperUserHome();
          } else {
            return WrapperAdminHome(user.uid);
          }
        } else {
          print('This user email is not verified');
          signOut();
          pUserType.emailVarified = false;
          return Authenticate();
        }

      }
     
    }
  }
}
