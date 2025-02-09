import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.blueAccent),
    home: SplashScreen(),
  ));
}

