import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
 final spinkit = SpinKitChasingDots(
  color: Colors.grey[200],
  size: 50.0,
);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: spinkit,
        ),
      ),
    );
  }
}