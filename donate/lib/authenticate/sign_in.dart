import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/authenticate/DonorOrOrg.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertest/screen/admin/adminHome.dart';
import 'package:fluttertest/screen/donor/search_page.dart';
import 'package:fluttertest/screen/guestDonor/guestDonor_home.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertest/provider/userTypeProvider.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../shared/loading.dart';
import 'forgorPassword.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  final String assetName = 'assets/facebook.svg';

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> signInWithGoogle() async {
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
      _firebaseAuth.signInWithCredential(credential).then((value) {
        print('uid iuy');
        print(value.user.uid);
      });
      print('uid is ...');
      // result.user.uid;

      print('id token is');
      print(_auth.currentUser.getIdToken());
      print('result');
    } catch (e) {}
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

  void _loginWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    print('Google sign in');
  }

  @override
  Widget build(BuildContext context) {
    final pUserType = Provider.of<PUserType>(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              
            ),
            
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                      height:170,
                      width: 275,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/DONAID.jpg',
                              ),
                      fit: BoxFit.fill)),
                     ),
                      
                    ],
                  ),
                  Container(
                      padding:
                          EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an email' : null,
                              decoration: InputDecoration(
                                  labelText: 'EMAIL',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green))),
                              controller: emailController,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              validator: (val) => val.length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                              decoration: InputDecoration(
                                  labelText: 'PASSWORD',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green))),
                              obscureText: true,
                              controller: passwordController,
                            ),
                            SizedBox(height: 40.0),
                            //Login
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  pUserType.emailVarified = true;
                                });

                                print(emailController.text);
                                print(passwordController.text);
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('UserType')
                                      .where("email",
                                      isEqualTo:
                                      emailController.text.trim())
                                      .get()
                                      .then((value) async{
                                    if (value.docs.length > 0) {
                                      print("33333333333333333");
                                      print(value.docs[0].id);
                                      print(value.docs[0]["Uid"]);
                                      print(value.docs[0]["status"]);
                                      print(value.docs[0]["email"]);
                                      print("33333333333333333");
                                      if (value.docs[0]["status"] ) {
                                        dynamic result = _auth
                                            .signInWithEmailAndPassword(
                                            emailController.text,
                                            passwordController.text)
                                            .then((value) async {
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                        if (result == null) {
                                          setState(() {
                                            loading = false;
                                            error =
                                            'Could not sign in with those credentials';
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          loading = false;
                                          Get.snackbar("Alert",
                                              "Your account is not approved by admin.",
                                              backgroundColor: Colors.black,
                                              colorText: Colors.white);
                                          error =
                                          "Alert!!!..Your account is not approved by admin.";
                                        });
                                      }
                                    } else {
                                      dynamic result = await _auth
                                          .signInWithEmailAndPassword(
                                          emailController.text,
                                          passwordController.text)
                                          .then((value) async {
                                        setState(() {
                                          loading = false;
                                        });
                                      });
                                      if (result == null) {
                                        setState(() {
                                          loading = false;
                                          error =
                                          'Could not sign in with those credentials';
                                        });
                                      }
                                      
                                    }

                                  });
                                }
                              },
                              child: Container(
                                height: 40.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.red,
                                  elevation: 7.0,
                                  child: Center(
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            pUserType.emailVarified == false
                                ? SizedBox(
                                    height: 7,
                                  )
                                : SizedBox(),
                            pUserType.emailVarified == false
                                ? Text(
                                    'Please verify your email',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : SizedBox(),
                            SizedBox(height: 12.0),
                            Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'New to Donaid ?',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: Center(
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => GuestHome(null)));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 80),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Guest Sign-In',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              dynamic result = await _auth.loginWithFacebook();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdminHome(null)));
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.blue[800],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                      height: 30,
                                      color: Colors.white,
                                      image: AssetImage('assets/facebook.png')),
                                  Text(
                                    'Facebook',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              dynamic result = await _auth.signInWithGoogle();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdminHome(null)));
                              if (result != null) {
                                print('user registration is : ${result.uid}');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue[800],
                                  borderRadius: BorderRadius.circular(5)),
                              height: 45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    child: Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/google.png')),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Google',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
