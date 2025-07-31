import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:human_body_parts/homeScreen.dart';

class CheckInternet extends StatefulWidget {
  @override
  State<CheckInternet> createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckInternet> {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _connectivity.onConnectivityChanged.listen((_) {
      _checkInternetConnection(); // every time connection changes, re-check real internet
    });
  }

  Future<void> _checkInternetConnection() async {
    try {
      final result = await http.get(Uri.parse('https://google.com')).timeout(Duration(seconds: 3));
      _connectionController.add(result.statusCode == 200);
    } catch (e) {
      _connectionController.add(false);
    }
  }

  @override
  void dispose() {
    _connectionController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _connectionController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SplashScreen();
        }

        if (snapshot.data == false) {
          return NoInternetScreen(onRetry: _checkInternetConnection);
        }

        return HomeScreen();
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}


class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  NoInternetScreen({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "❌ No Internet Connection",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text("Check Again"),
            )
          ],
        ),
      ),
    );
  }
}
