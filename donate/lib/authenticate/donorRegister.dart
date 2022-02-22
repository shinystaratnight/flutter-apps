import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/provider/userTypeProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

class DonorRegister extends StatefulWidget {
  int selectedButton;
  Function toggleView;

  DonorRegister({this.selectedButton, this.toggleView});

  @override
  _DonorRegisterState createState() => _DonorRegisterState();
}

class _DonorRegisterState extends State<DonorRegister> {
  final AuthService _auth = AuthService();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNoController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool passwordMatch = true;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  final _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Timer timer;
  User currentUser;

  File imageFile;
  String fileName;
  String imageUrl;
  String avatarPath = '';
  String address = '';

  Future<int> checkEmailVerified() async {
    await currentUser.reload();
    var u = await _auth.currentUser;
    if (u.emailVerified) {
      print('verify');
      timer.cancel();
      return 1;
    } else {
      print('not verify');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pUserType = Provider.of<PUserType>(context);
    return Scaffold(
      // backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Sign up Donor'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Registration',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please enter your personal details below to Proceed',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                'Personal Details',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: CircleAvatar(
                          // Profile image
                          radius: 70,
                          backgroundColor: Colors.grey[300],
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.grey[800]),
                              color: Colors.grey[500],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageFile == null
                                    ? Image.asset('assets/avatar.png').image
                                    : FileImage(imageFile),
                              ),
                            ),
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.edit,
                                  size: 30,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                        onTap: () {
                          // Tap listener to edit profile image
                          pickImage();
                        },
                      ),
                      TextFormField(
                        // Add nickname
                        validator: (val) =>
                            val.isEmpty ? 'Enter nickname' : null,
                        decoration: InputDecoration(
                            labelText: 'Nickname',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        controller: nicknameController,
                      ),
                      TextFormField(
                        validator: (val) => val.isEmpty ? 'Enter a name' : null,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        controller: nameController,
                      ),
                      SizedBox(height: 20.0),
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
                                borderSide: BorderSide(color: Colors.green))),
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
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                        controller: passwordController,
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) =>
                            val.length < 6 ? 'Phone number' : null,
                        decoration: InputDecoration(
                            labelText: 'Phone #',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                        controller: phoneNoController,
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                        controller: addressController,
                      ),

                      SizedBox(height: 5.0),
                      SizedBox(height: 40.0),
                      GestureDetector(
                        onTap: () async {
                          print(emailController.text);
                          print(passwordController.text);
                          if (_formKey.currentState.validate()) {
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text);

                            if (result == null) {
                              setState(() {
                                error = 'Please supply a valid email';
                              });
                            } else {
                              Navigator.pop(context);
                              widget.toggleView();
                              print('in registration else');
                              await _firestoreInstance
                                  .collection('UserType')
                                  .add({
                                'Name': nameController.text,
                                'SelectedUser': widget.selectedButton,
                                'Uid': result.uid
                              });
                              // save donor user to firestore
                              await _saveDonorUser(result);

                              await _auth.signOut();
                              pUserType.getUserType(context);
                            }
                          }
                        },
                        child: Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.red,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage() async {
    // Pick image from gallery in phone
    final _imagePicker = ImagePicker();
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        imageUrl = (imageFile.path);
      });
    } else {
      print('No image selected!'); //alert if no image is selected
    }
  }

  _saveDonorUser(result) async {
    if (imageFile != null) {
      String fileName = basename(imageFile.path);
      // Reference newRef = FirebaseStorage.instance.ref(imageUrl);
      Reference newRef = FirebaseStorage.instance.ref(fileName);
      newRef.putFile(imageFile).whenComplete(() async {
        avatarPath = await newRef.getDownloadURL();
        await _firestoreInstance.collection('DonorUser').doc(result.uid).set({
          'uid': result.uid,
          'avatar': avatarPath,
          'password': passwordController.text,
          'nickname': {'value': nicknameController.text, 'visible': false},
          'name': {'value': nameController.text, 'visible': false},
          'email': {'value': emailController.text, 'visible': false},
          'phone': {'value': phoneNoController.text},
          'address': {'value': addressController.text, 'visible': false},
        });
      });
    } else {
      await _firestoreInstance.collection('DonorUser').doc(result.uid).set({
        'uid': result.uid,
        'avatar': avatarPath,
        'password': passwordController.text,
        'nickname': {'value': nicknameController.text, 'visible': false},
        'name': {'value': nameController.text, 'visible': false},
        'email': {'value': emailController.text, 'visible': false},
        'phone': {'value': phoneNoController.text, 'visible': false},
        'address': {'value': addressController.text, 'visible': false},
      });
    }
  }
}
