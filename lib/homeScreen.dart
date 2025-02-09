import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:human_body_parts/data/dataoffile.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  static const Color iconColor = Color(0xFFFFC4A0);
  static const Color backgroundColor = Color(0xFF04A3B6);
  static const Color textColor = Color(0xFF04A3B6);

  BannerAd bAd = new BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: BannerAdListener(onAdLoaded: (ad) {
        print('ads loaded........');
      }, onAdFailedToLoad: (ad, err) {
        print('ads faild........');
        ad.dispose();
      }, onAdOpened: (ad) {
        print('add loaded----------');
      }),
      request: AdRequest());

  var currentScreenIndex = 0;
  final player = AudioPlayer();

  void next() {
    setState(() {
      currentScreenIndex = (currentScreenIndex + 1) % DataOfData.length;
    });
    playsound(DataOfData[currentScreenIndex].sound);
  }

  void previous() {
    setState(() {
      currentScreenIndex = (currentScreenIndex - 1) % DataOfData.length;
    });
    playsound(DataOfData[currentScreenIndex].sound);
  }

  void playsound(String soundpath) async {
    try {
      await player.play(AssetSource(soundpath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(context) {
    final currentScreen = DataOfData[currentScreenIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF04A3B6),
        centerTitle: true,
        title: Text(
          'Human Body parts',
          style: TextStyle(
            color: Color(0xFFFFC4A0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child:
                    Image.asset(currentScreen.img), //dynamic  one by on fetch
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //previous button function fetch from widgetfun file............
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        backgroundColor: iconColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () => previous(), //argument type function
                    child: Icon(
                      Icons.arrow_back, //argument type function
                      size: 50,
                      color: textColor,
                      // color: color(0xC9EBB796),
                    )),
                //play button function fetch from playsound fun...........
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        backgroundColor: Color(0xFFEAB595),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () => playsound(DataOfData[currentScreenIndex]
                        .sound), //argument type function
                    child: Icon(
                      Icons.not_started_outlined, //argument type function
                      size: 50,
                      color: textColor,
                      // color: color(0xC9EBB796),
                    )),
                //next button function fetch from widgetfun file............
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        backgroundColor: iconColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () => previous(), //argument type function
                    child: Icon(
                      Icons.arrow_forward, //argument type function
                      size: 50,
                      color: textColor, // color: color(0xC9EBB796),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // Container(
            //   height: 50,
            //   color: Colors.white,
            //   width: double.infinity,
            // )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: AdWidget(
          ad: bAd..load(),
          key: UniqueKey(),
        ),
      ),
    );
  }
}
