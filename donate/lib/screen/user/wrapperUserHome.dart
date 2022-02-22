import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'userHome.dart';

class WrapperUserHome extends StatefulWidget {
  @override
  _WrapperUserHomeState createState() => _WrapperUserHomeState();
}

class _WrapperUserHomeState extends State<WrapperUserHome> {
  @override
  Widget build(BuildContext context) {
    return UserHome();
    
  }
}
