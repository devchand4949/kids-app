import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:human_body_parts/about%20screen.dart';
import 'package:human_body_parts/interstial%20ad.dart';
import 'package:human_body_parts/model/modelui.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/dataoffile.dart';

// ====== PROVIDER =======
class HomeProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  int _currentIndex = 0;
  bool _isConnected = true;
  bool _isPlaying = false;

  BannerAd? _bannerAd;
  AdWidget? _adWidget;
  static const _bannerAdId = 'ca-app-pub-6093358640755241/5201223690';

  bool get isPlaying => _isPlaying;
  int get currentIndex => _currentIndex;
  bool get isConnected => _isConnected;
  BannerAd? get bannerAd => _bannerAd;
  AdWidget? get adWidget => _adWidget;
  ModelUi get currentData => DataOfData[_currentIndex];

  HomeProvider(BuildContext context) {
    _checkInternet();
    _initBannerAd(context);

    _player.onPlayerComplete.listen((event) {
      _isPlaying = false;
      notifyListeners();
    });
  }

  void _checkInternet() async {
    final result = await Connectivity().checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    notifyListeners();

    Connectivity().onConnectivityChanged.listen((result) {
      _isConnected = result != ConnectivityResult.none;
      notifyListeners();
    });
  }

  void _initBannerAd(BuildContext context) async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) return;

    _bannerAd = BannerAd(
      size: size,
      adUnitId: _bannerAdId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adWidget = AdWidget(ad: ad as BannerAd);
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: AdRequest(),
    )..load();
  }

  void playSound(String soundPath) async {
    try {
      if (_isPlaying) {
        await _player.stop();
        _isPlaying = false;
      } else {
        await _player.play(AssetSource(soundPath));
        _isPlaying = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Sound error: $e');
    }
  }

  void stopAudio() async {
    await _player.stop();
    _isPlaying = false;
    notifyListeners();
  }

  void next(BuildContext context) {
    _isPlaying = false;
    context.read<IntertitialAdProvider>().tryShowAd(() {
      _currentIndex = (_currentIndex + 1) % DataOfData.length;
      playSound(currentData.sound);
      notifyListeners();
    });
  }

  void previous(BuildContext context) {
    _isPlaying = false;
    context.read<IntertitialAdProvider>().tryShowAd(() {
      _currentIndex = (_currentIndex - 1 + DataOfData.length) % DataOfData.length;
      playSound(currentData.sound);
      notifyListeners();
    });
  }
}

// ====== SCREEN =======
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(context),
      child: HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final data = provider.currentData;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF04A3B6),
        centerTitle: true,
        title: const Text(
          'Human Body Parts',
          style: TextStyle(
            color: Color(0xFFFFC4A0),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              final provider = context.read<HomeProvider>();
              if (provider.isPlaying) {
                provider.stopAudio(); // <-- stop audio if playing
              }
          Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));},
            icon:  Icon(Icons.read_more_outlined, color: Color(0xFFFFC4A0),size: isTablet ? 35 : 30,),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF04A3B6),
        padding: EdgeInsets.all(isTablet ? 24 : 12),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                data.img,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: isTablet ? 30 : 16),
            LayoutBuilder(
              builder: (context, constraints) {
                double buttonSize = isTablet ? 80 : constraints.maxWidth * 0.18;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _circleButton(
                      icon: Icons.arrow_back,
                      size: buttonSize,
                      onPressed: () => provider.previous(context),
                    ),
                    _circleButton(
                      icon: provider.isPlaying
                          ? Icons.stop_circle
                          : Icons.not_started_outlined,
                      size: buttonSize,
                      backgroundColor: const Color(0xFFEAB595),
                      onPressed: () => context.read<IntertitialAdProvider>().tryShowAd(() {
                        provider.playSound(data.sound);
                      }),
                    ),
                    _circleButton(
                      icon: Icons.arrow_forward,
                      size: buttonSize,
                      onPressed: () => provider.next(context),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: provider.isConnected && provider.adWidget != null
          ? Container(
        height: 60,
        width: provider.bannerAd!.size.width.toDouble(),
        color: Colors.white,
        child: provider.adWidget!,
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required double size,
    required VoidCallback onPressed,
    Color backgroundColor = const Color(0xFFFFC4A0),
    Color iconColor = const Color(0xFF04A3B6),
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
        padding: EdgeInsets.all(size * 0.2),
      ),
      onPressed: onPressed,
      child: Icon(icon, size: size * 0.6, color: iconColor),
    );
  }
}
