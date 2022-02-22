import 'package:flutter/material.dart';


/// This file is manage to push navigator for next screen
/// Author: Joyshree Chowdhury
/// All rights reserved

/// Go to next screen with push
void nextScreen(context, page) {// Add
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

/// Go to next screen with replace
void nextScreenReplace(context, page) { // Replace
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}
