import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class OrganizationSettings extends StatelessWidget {
  const OrganizationSettings ({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}