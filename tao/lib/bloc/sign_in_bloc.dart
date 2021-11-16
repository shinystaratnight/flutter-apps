import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInBloc extends ChangeNotifier {
  SignInBloc() {
    checkSignIn();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _loginSuccess;
  String? get loginSuccess => _loginSuccess;

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googlSignIn.signIn();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        User userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user!;

        //
        setSignIn();

        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }

  Future userSignout() async {
    // if(_signInProvider == 'apple'){
    //   await _firebaseAuth.signOut();
    // }
    // else if (_signInProvider == 'facebook'){
    //   await _firebaseAuth.signOut();
    //   await _fbLogin.logOut();
    // }else if(_signInProvider == 'email'){
    //   await _firebaseAuth.signOut();
    // }

    // else{
    await _firebaseAuth.signOut();
    await _googlSignIn.signOut();
    // }
  }

  Future afterUserSignOut() async {
    await userSignout().then((value) async {
      await clearAllData();
      _isSignedIn = false;
      notifyListeners();
    });
  }

  Future clearAllData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
