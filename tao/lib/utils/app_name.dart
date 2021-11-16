import 'package:flutter/material.dart';

class AppName extends StatelessWidget {
  final double fontSize;
  const AppName({Key? key, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Tao', //first part
        style: TextStyle(
            fontFamily: 'SpaceMono',
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: Colors.grey[800]),
        children: <TextSpan>[
          TextSpan(
              text: 'App', //second part
              style:
                  TextStyle(fontFamily: 'SpaceMono', color: Colors.lightBlue)),
        ],
      ),
    );
  }
}
