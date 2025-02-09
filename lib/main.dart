import 'dart:async';
import 'package:human_body_parts/homeScreen.dart';
import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() {
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.blueAccent),
    home: SplashScreen(),
  ));
}

