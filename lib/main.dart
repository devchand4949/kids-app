import 'package:flutter/material.dart';
import 'package:human_body_parts/interstial%20ad.dart';
import 'package:provider/provider.dart';
import 'splashscreen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // ✅ Set child-directed treatment for kids apps
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      maxAdContentRating: MaxAdContentRating.g, // optional but recommended
    ),
  );

  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => IntertitialAdProvider()..loadAd()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blueAccent),
      home: SplashScreen(),
    ),
  ));
}
//