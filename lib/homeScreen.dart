import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:human_body_parts/model/modelui.dart';
import 'package:human_body_parts/data/dataoffile.dart';
import 'package:human_body_parts/widgetFun.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
      currentScreenIndex =
          (currentScreenIndex - 1 ) % DataOfData.length;
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
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Human Body parts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: Image.asset(currentScreen.img), //dynamic  one by on fetch
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //previous button function fetch from widgetfun file
                Buttonfunpass(previous, Icons.arrow_back,Colors.blueAccent),
                //play button function fetch from playsound fun
                Buttonfunpass(() => playsound(currentScreen.sound),
                    Icons.not_started_outlined,Colors.blue),
                //next button function fetch from widgetfun file
                Buttonfunpass(next, Icons.arrow_forward,Colors.blueAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
