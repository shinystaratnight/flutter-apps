import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertest/screen/admin/adminHome.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer timer;
  User currentUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // create user obj based on firebase user
  Usr _userFromFirebaseUser(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? Usr(uid: user.uid) : null;
  }

  //getter: auth change user
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // Stream<String> get onAuthStateChanged =>
  //     _auth.authStateChanges(
  //           (User user) => user?.uid,
  //     );

  // sign in anon
  // Future signInAnon() async {
  //   try {
  //     UserCredential result = await _auth.signInAnonymously();
  //     User user = result.user;
  //     return user;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      currentUser = result.user;
      await saveDataToSP(user.uid);
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      currentUser = result.user;
      print('sending email verification');
      await currentUser.sendEmailVerification();
      // Timer.periodic(Duration(seconds: 5), (timer) {
      //   checkEmailVerified();
      // });
      return _userFromFirebaseUser(currentUser);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      // UserCredential result =
      //     await
      UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<User> loginWithFacebook() async {
    try {
      print('in log in with facebook');
      final facebookLogInResult = await FacebookAuth.instance.login();
      final userData = FacebookAuth.instance.getUserData();

      final faceBookAuthCredential = await FacebookAuthProvider.credential(
          facebookLogInResult.accessToken.token);
      await FirebaseAuth.instance.signInWithCredential(faceBookAuthCredential);

      await FirebaseFirestore.instance.collection('users');
    } on Exception catch (e) {
      print('error');
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Joya
  Future saveDataToSP(uid) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('uid', uid);
  }

  //check if email verified
// Future<int> checkEmailVerified() async {
//   await currentUser.reload();
//   var u = await _auth.currentUser;
//   if (u.emailVerified) {
//     print('verify');
//     timer.cancel();
//     return 1;
//   } else {
//     print('not verify');
//     return 0;
//   }
// }

  updateEmail(String newEmail, String oldEmail, String oldPw) {
    if (currentUser == null) {
      signInWithEmailAndPassword(oldEmail, oldPw).then((value) {
        currentUser.updateEmail(newEmail).then((_) {});
      });
    } else {
      currentUser.updateEmail(newEmail).then((_) {});
    }
  }

  updatePassword(String newPassword, String oldEmail, String oldPw) {
    if (currentUser == null) {
      signInWithEmailAndPassword(oldEmail, oldPw).then((value) {
        currentUser.updatePassword(newPassword).then((_) {});
      });
    } else {
      currentUser.updatePassword(newPassword).then((_) {});
    }
  }
}
