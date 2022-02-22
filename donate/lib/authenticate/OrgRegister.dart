import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertest/provider/userTypeProvider.dart';
import 'package:fluttertest/shared/loading.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

class OrgRegister extends StatefulWidget {
  int selectedButton;
  Function toggleView;

  OrgRegister({this.selectedButton, this.toggleView});

  @override
  _OrgRegisterState createState() => _OrgRegisterState();
}

class _OrgRegisterState extends State<OrgRegister> {
  final AuthService _auth = AuthService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNoController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final categoryController = TextEditingController();
  bool passwordMatch = true;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  final _firestoreInstance = FirebaseFirestore.instance;
  File file;
  List<String> category = ['Religion', 'Homeless', 'Education', 'Other'];
  bool loading = false;
  bool flag = false;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pUserType = Provider.of<PUserType>(context);
    return loading == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text('Sign up Org'),
            ),
            body: SingleChildScrollView(
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
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
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
                        padding:
                            EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a name' : null,
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green))),
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
                            SizedBox(height: 20.0),
                            TextFormField(
                              validator: (val) => val.length < 6
                                  ? 'Enter a valid address'
                                  : null,
                              decoration: InputDecoration(
                                  labelText: 'Address',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green))),
                              controller: addressController,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              validator: (val) => val.length < 6
                                  ? 'Enter a valid phone number'
                                  : null,
                              decoration: InputDecoration(
                                  labelText: 'Phone #',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green))),
                              controller: phoneNoController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                      width: 100,
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 60,
                                      child: TextFormField(
                                        validator: (val) => val.isEmpty
                                            ? 'Enter Category'
                                            : null,
                                        readOnly: true,
                                        controller: categoryController,
                                      ),
                                    ),
                                  ),
                                  
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                      items: category.map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        setState(() {
                                          // category = _;
                                          categoryController.text = _;
                                        });
                                      },
                                    )),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await selectFile();
                              },
                              child: Container(
                                  height: 45,
                                  width: 350,
                                  decoration: BoxDecoration(
                                      color: Colors.red[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload),   
                                Text(
                                  'Required: Upload File To Verify Account',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                              )
                          ],
                        ),
                      ),
                            ),
                            flag==false?SizedBox():Text('Select a Document',style:TextStyle(color: Colors.red)),
                            file == null ? SizedBox() : Text('$file'),
                            SizedBox(height: 5.0),
                            SizedBox(height: 20.0),
                            GestureDetector(
                              onTap: () async {
                                print(emailController.text);
                                print(passwordController.text);
                                if(file==null)
                                  {
                                    print('NO value');
                                    setState(() {
                                      flag = true;
                                    });
                                  }
                                  else{
                                    setState(() {
                                      flag = false;
                                    });
                                  }
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
                                    print('result is ${result.uid}');
                                    if (file != null) {
                                      try {
                                        print('in upload file');
                                        final fileName = file.path;
                                        final destination = 'files/';
                                        final ref = FirebaseStorage.instance
                                            .ref(destination);
                                        ref.putFile(file);
                                        print('DONE ');
                                        final snapshot =
                                            await ref.getDownloadURL();
                                        print('ref is $snapshot');
                                      } catch (e) {
                                        print('Error is $e');
                                      }
                                    } else {
                                      print('error');
                                    }
                                    setState(() {
                                      
                                    });
                                    await _firestoreInstance
                                        .collection('UserType')
                                        .add({
                                      'Category': categoryController.text,
                                      'SelectedUser': widget.selectedButton,
                                      'Uid': result.uid,
                                      'Name': nameController.text,
                                      'email': emailController.text.trim(),
                                      "status":false //this status used to verified (true) or un-verified (false)
                                    });

                                    pUserType.getUserType(context);
                                    Navigator.pop(context);
                                    widget.toggleView();
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
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          )
        : Loading();
  }
}