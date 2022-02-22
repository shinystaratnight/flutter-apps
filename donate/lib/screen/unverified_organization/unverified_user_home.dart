import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/unverified_organization/unverified_beneficiary.dart';
import 'package:fluttertest/screen/unverified_organization/unverified_events.dart';
import 'package:path/path.dart';
import '../../services/auth.dart';

class UnverifiedUserHome extends StatefulWidget {
  @override
  _UnverifiedUserHome createState() => _UnverifiedUserHome();
}

class _UnverifiedUserHome extends State<UnverifiedUserHome> {
  final AuthService _auth = AuthService();
  File file;

    Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path);
      
    });
  }

  @override
  //BUILD METHOD
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Donaid'),
          backgroundColor: Colors.red,
          actions: [
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.popUntil(context, ModalRoute.withName("/"));
                },
                icon: Icon(Icons.person),
                label: Text('Sign out'))
          ],
        ),
        body: Center(
          child: 
            GestureDetector(
                  onTap:() async {
                    await selectFile();
                    if (file != null) {
                              try {
                                print('in upload file');
                                final fileName = basename(file.path);
                                final destination = 'files/$fileName';
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
                              'Upload File To Verify Account',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
        ),
  
        ),
        drawer: const OrganizationDrawer()
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
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
                  MaterialPageRoute(builder: (context) => UnverifiedUserHome()),
                );
              },
            ),
            ListTile(
              title: const Text('Events'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UnverifiedOrganizationEvents()),
                );
              },
            ),
            ListTile(
              title: const Text('Beneficiaries'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UnverifiedOrganizationBeneficiaries()),
                );
              },
            ),
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
