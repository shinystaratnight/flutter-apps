import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'userHome.dart';

class OrganizationProfile extends StatelessWidget {
  const OrganizationProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Profile Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter organization name'),
                ),
                // TextField(
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       hintText: 'Enter phone number'),
                // ),
                Text('Phone Number')
              ]),
        ),
      ),
      // Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: const Text('Go back!'),
      //   ),
      // ),

    );
  }
}
