import 'package:flutter/material.dart';
import 'dart:async'; // For the Timer
import 'package:startapp_sdk/startapp.dart'; // Import Start.io SDK

class InterstitialAdWidget extends StatefulWidget {
  @override
  _InterstitialAdWidgetState createState() => _InterstitialAdWidgetState();
}

class _InterstitialAdWidgetState extends State<InterstitialAdWidget> {
  var startAppSdk = StartAppSdk();
  StartAppInterstitialAd? interstitialAd;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Enable test ads, remember to disable for release
    startAppSdk.setTestAdsEnabled(true);

    // Start the timer to show an ad every 5 minutes
    _startAdTimer();

    // Load the initial interstitial ad
    _loadInterstitialAd();
  }

  void _startAdTimer() {
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      _showInterstitialAd();
    });
  }

  void _loadInterstitialAd() {
    startAppSdk.loadInterstitialAd().then((ad) {
      setState(() {
        interstitialAd = ad;
      });
    }).onError((error, stackTrace) {
      debugPrint("Error loading Interstitial ad: $error");
    });
  }

  void _showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show().then((shown) {
        if (shown) {
          setState(() {
            interstitialAd = null;
            _loadInterstitialAd();  // Load a new ad after showing
          });
        }
      }).onError((error, stackTrace) {
        debugPrint("Error showing Interstitial ad: $error");
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _showInterstitialAd,
          child: Text("Show Interstitial Ad Now"),
        ),
      ),
    );
  }
}
