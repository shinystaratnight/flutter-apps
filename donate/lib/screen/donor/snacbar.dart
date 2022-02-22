import 'package:flutter/material.dart';

/// Show message into scacbar

///Author: Joyshree Chowdhury
/// All rights reserved
void openSnacbar(_scaffoldKey, snacMessage) {
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Container(
      alignment: Alignment.centerLeft,
      height: 50,
      child: Text(
        snacMessage,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    ),
    action: SnackBarAction(
      label: 'Ok',
      textColor: Colors.blueAccent,
      onPressed: () {},
    ),
  ));
}
