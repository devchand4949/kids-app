import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class IntertitialAdProvider with ChangeNotifier {
  InterstitialAd? _interstitialAd;
  static const _adUnitId = 'ca-app-pub-6093358640755241/5009652000';
  DateTime _lastAdShown = DateTime.now().subtract(Duration(minutes: 3));
  bool get isAdReady => _interstitialAd != null;

  void loadAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId, // Replace with real ID
      request: const AdRequest(
          nonPersonalizedAds: true
      ),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          debugPrint('Ad failed to load: $error');
        },
      ),
    );
  }

  void tryShowAd(VoidCallback onAdComplete) {
    final now = DateTime.now();
    if (_interstitialAd != null && now.difference(_lastAdShown).inMinutes >= 2) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _lastAdShown = DateTime.now();
          loadAd();
          onAdComplete();
        },
      );
      _interstitialAd!.show();
    } else {
      onAdComplete(); // No ad shown
    }
  }
}
