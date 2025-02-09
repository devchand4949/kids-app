import 'dart:async';

import 'package:flutter/material.dart';
import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
