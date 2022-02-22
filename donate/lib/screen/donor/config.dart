import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// This class manages app information ( appname,color and language)
/// Author: Joyshree Chowdhury
/// All rights reserved
class Config {
  final String appName = 'Donaid';

  /**
   * App theme color
   */
  final Color appColor = Colors.deepPurpleAccent;

  /**
   * Language set up , english & french & arabic & japanese
   */
  final List<String> languages = ['English', 'French', 'Arabic', 'Japanese'];

}


