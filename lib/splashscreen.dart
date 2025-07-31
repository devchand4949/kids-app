import 'dart:async';

import 'package:flutter/material.dart';
import 'package:human_body_parts/connectivity.dart';
import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CheckInternet()));
    });
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF04A3B6),
        child: Center(
          child: Image.asset('assets/images/splas.png')
        ),
      ),
    );
  }
}
