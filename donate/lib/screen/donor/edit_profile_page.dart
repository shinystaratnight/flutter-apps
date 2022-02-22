import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/donor/snacbar.dart';
import 'package:fluttertest/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donor_user.dart';
import 'donor_user_bloc.dart';
import 'package:path/path.dart' as p;

/// Edit profile screen
/// avatar, name, nickname, email, password, phone, address
/// Author: Joyshree Chowdhury
/// All rights reserved
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController,
      phoneController,
      addressController,
      nicknameController,
      emailController,
      passwordController;
  var _fireStore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  String imageUrl;

  File imageFile;
  String fileName;
  bool updating = false;
  bool isDuLoaded = false;
  DonorUser du;
  String avatarPath = '';

  bool visibleNickname = false;
  bool visibleName = false;
  bool visibleEmail = false;
  bool visibleAddress = false;
  bool visiblePhone = false;
  bool visiblePassword = true;

  Future pickImage() async {
    /** Pick image from gallery in phone

     */
    final _imagePicker = ImagePicker();
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        imageUrl = (imageFile.path);
      });
    } else {
      /**
       * alert if no image is selected
      */
      print('No image selected!');
    }
  }

  @override
  void initState() {
    // Initialize page
    _handleDonorUser();

    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    nicknameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  // Build screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // Appbar
        backgroundColor: Colors.red,
        title: const Text('edit profile').tr(),
      ),
      body: ListView(
        // Body with listview widget(CircleAvatar, Name, Phone)
        padding: const EdgeInsets.all(25),
        children: [
          InkWell(
            child: CircleAvatar(
              // Profile image
              radius: 70,
              backgroundColor: Colors.grey[300],
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey[800]),
                  color: Colors.grey[500],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageFile == null
                        ? avatarPath == ''
                            ? Image.asset('assets/avatar.png').image
                            : NetworkImage(avatarPath)
                        : FileImage(imageFile),
                  ),
                ),
                child: (imageFile == null && avatarPath == '')
                    ? Container()
                    : Stack(
                        children: [
                          // Edit profile avatar with icon
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Icon(
                              Icons.edit,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                          // Delete profile avatar
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                if (imageFile != null || avatarPath != '') {
                                  setState(() {
                                    imageFile = null;
                                    avatarPath = '';
                                  });
                                }
                              },
                              child: Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            onTap: () {
              // Tap listener to edit profile image
              pickImage();
            },
          ),
          SizedBox(
            height: 50,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                // Name field
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter new name'.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    label: Text('name').tr(),
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (!visibleName) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('confirm public').tr(),
                                  content: Text(
                                          'are you sure you want to make it public?')
                                      .tr(),
                                  actions: [
                                    TextButton(
                                      child: Text('no').tr(),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                        child: Text('yes').tr(),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          setState(() {
                                            visibleName = true;
                                          });
                                        }),
                                  ],
                                );
                              });
                        } else {
                          setState(() {
                            visibleName = !visibleName;
                          });
                        }
                      },
                      child: Icon(
                        !visibleName
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value.isEmpty) return "this field can't be empty".tr();
                    if (value.contains(RegExp(r'[0-9]'))) {
                      return "this field can't contains number";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Nick name field
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter new nick name'.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    label: Text('nickname').tr(),
                    prefixIcon: Icon(Icons.person_outlined),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (!visibleNickname) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('confirm public').tr(),
                                  content: Text(
                                          'are you sure you want to make it public?')
                                      .tr(),
                                  actions: [
                                    TextButton(
                                      child: Text('no').tr(),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                        child: Text('yes').tr(),
                                        onPressed: () async {
                                          Navigator.pop(context);

                                          setState(() {
                                            visibleNickname = true;
                                          });
                                        }),
                                  ],
                                );
                              });
                        } else {
                          setState(() {
                            visibleNickname = !visibleNickname;
                          });
                        }
                      },
                      child: Icon(
                        !visibleNickname
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  controller: nicknameController,
                  validator: (value) {
                    if (value.isEmpty) return "this field can't be empty".tr();
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Email field
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter new email'.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    label: Text('email').tr(),
                    prefixIcon: Icon(Icons.email_outlined),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (!visibleEmail) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('confirm public').tr(),
                                  content: Text(
                                          'are you sure you want to make it public?')
                                      .tr(),
                                  actions: [
                                    TextButton(
                                      child: Text('no').tr(),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                        child: Text('yes').tr(),
                                        onPressed: () async {
                                          Navigator.pop(context);

                                          setState(() {
                                            visibleEmail = true;
                                          });
                                        }),
                                  ],
                                );
                              });
                        } else {
                          setState(() {
                            visibleEmail = !visibleEmail;
                          });
                        }
                      },
                      child: Icon(
                        !visibleEmail
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value.isEmpty) return "this field can't be empty".tr();
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Password field
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter new password'.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    label: Text('password').tr(),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          visiblePassword = !visiblePassword;
                        });
                      },
                      child: Icon(
                        !visiblePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  obscureText: visiblePassword,
                  controller: passwordController,
                  validator: (value) {
                    if (value.isEmpty) return "this field can't be empty".tr();
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Phone number field
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter new phone number'.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    label: Text('phone number').tr(),
                    prefixIcon: Icon(Icons.phone_android),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (!visiblePhone) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('confirm public').tr(),
                                  content: Text(
                                          'are you sure you want to make it public?')
                                      .tr(),
                                  actions: [
                                    TextButton(
                                      child: Text('no').tr(),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                        child: Text('yes').tr(),
                                        onPressed: () async {
                                          Navigator.pop(context);

                                          setState(() {
                                            visiblePhone = true;
                                          });
                                        }),
                                  ],
                                );
                              });
                        } else {
                          setState(() {
                            visiblePhone = !visiblePhone;
                          });
                        }
                      },
                      child: Icon(
                        !visiblePhone
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) return "this field can't be empty".tr();
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                // Address field
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter new address'.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    label: Text('address').tr(),
                    prefixIcon: Icon(Icons.place_outlined),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (!visibleAddress) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('confirm public').tr(),
                                  content: Text(
                                          'are you sure you want to make it public?')
                                      .tr(),
                                  actions: [
                                    TextButton(
                                      child: Text('no').tr(),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                        child: Text('yes').tr(),
                                        onPressed: () async {
                                          Navigator.pop(context);

                                          setState(() {
                                            visibleAddress = true;
                                          });
                                        }),
                                  ],
                                );
                              });
                        } else {
                          setState(() {
                            visibleAddress = !visibleAddress;
                          });
                        }
                      },
                      child: Icon(
                        !visibleAddress
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  controller: addressController,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith((states) => Colors.red),
                  textStyle: MaterialStateProperty.resolveWith(
                      (states) => TextStyle(color: Colors.white))),
              child: updating == true
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : Text(
                      'update profile',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ).tr(),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  handleUpdateData();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /** Get donor user from firebase
   *
   */
  _handleDonorUser() async {
    String uid = await getUidFromSp();
    final DonorUserBloc dub =
        Provider.of<DonorUserBloc>(context, listen: false);
    dub.getDonorUser(uid).then((_) {
      if (dub.isFind) {
        du = dub.donorUser;
        avatarPath = du.avatar;
        passwordController.text = du.password;
        nameController.text = du.name.value;
        addressController.text = du.address.value;
        phoneController.text = du.phone.value;
        nicknameController.text = du.nickname.value;
        emailController.text = du.email.value;
        visibleNickname = du.nickname.visible;
        visibleName = du.name.visible;
        visibleEmail = du.email.visible;
        visiblePhone = du.phone.visible;
        visibleAddress = du.address.visible;
        setState(() {
          isDuLoaded = true;
        });
      } else {}
    });
  }

  /** Get uid from saved sharedpreference
   *
   */
  Future getUidFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('uid');
  }

  /** Update donor user account information
   *
   */
  handleUpdateData() async {
    bool isUpdated = false;

    var name = nameController.text;
    var phone = phoneController.text;
    var address = addressController.text;
    var nickname = nicknameController.text;
    var email = emailController.text;
    var password = passwordController.text;

    String uid = await getUidFromSp();

    _updateEmailAndPassword();

    if (imageFile != null) {
      String fileName = p.basename(imageFile.path);
      Reference newRef = FirebaseStorage.instance.ref(fileName);
      newRef.putFile(imageFile).whenComplete(() async {
        avatarPath = await newRef.getDownloadURL();
        _setDataToFirebase(uid, avatarPath);
      });
    } else {
      if (name != du.name.value ||
          phone != du.phone.value ||
          address != du.address.value ||
          nickname != du.nickname.value ||
          email != du.email.value ||
          password != du.password ||
          avatarPath != du.avatar ||
          visibleName != du.name.visible ||
          visibleNickname != du.nickname.visible ||
          visibleEmail != du.email.visible ||
          visiblePhone != du.phone.visible ||
          visibleAddress != du.address.visible
      ) {
        isUpdated = true;
      }
    }

    if (isUpdated == true) {
      _setDataToFirebase(uid, avatarPath);
    }
  }

  /** Write donor user information to firestore
   *
   */
  _setDataToFirebase(String uid, String avatarPath) {
    _fireStore.collection('DonorUser').doc(uid).set({
      'avatar': avatarPath,
      'uid': uid,
      'password': passwordController.text,
      'name': {'value': nameController.text, 'visible': visibleName},
      'nickname': {
        'value': nicknameController.text,
        'visible': visibleNickname
      },
      'email': {'value': emailController.text, 'visible': visibleEmail},
      'phone': {'value': phoneController.text, 'visible': visiblePhone},
      'address': {'value': addressController.text, 'visible': visibleAddress},
    }).whenComplete(() {
      openSnacbar(scaffoldKey, 'Updated profile!');
    });
  }

  /** Update email and password to change
   *
   */
  _updateEmailAndPassword() {
    if (emailController.text != du.email.value) {
      _auth.updateEmail(emailController.text, du.email.value, du.password);
    }

    if (passwordController.text != du.password) {
      _auth.updatePassword(
          passwordController.text, du.email.value, du.password);
    }
  }
}
