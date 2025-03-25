import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class WatchPage extends StatefulWidget {
  final String tmdbId;

  const WatchPage({required this.tmdbId, Key? key}) : super(key: key);

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  late final WebViewController _controller;
  InterstitialAd? _interstitialAd;
  Timer? _adTimer;

  @override
  void initState() {
    super.initState();

    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Initialize AdMob and load the first interstitial ad
    MobileAds.instance.initialize();
    _loadInterstitialAd();

    // Start a timer for showing ads periodically
    _startAdTimer();

    // Initialize WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (!request.url.contains(widget.tmdbId)) {
              print('Blocked navigation to: ${request.url}');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://vidsrc.xyz/embed/movie/${widget.tmdbId}'));
  }

  // Load an interstitial ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-8360591759937694/2892815350', // Replace with your actual Ad Unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
          });
          // Set the full-screen callback
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _loadInterstitialAd(); // Load a new ad after the current one is shown
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print('Ad failed to show: $error');
              ad.dispose();
              _loadInterstitialAd(); // Attempt to load a new ad if the current one fails
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  // Show the interstitial ad if loaded
  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // Reset the ad to null after showing
    } else {
      print('Interstitial ad is not ready yet.');
    }
  }

  // Start a timer to show ads periodically (every 5 minutes)
  void _startAdTimer() {
    _adTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      _showInterstitialAd();
    });
  }

  @override
  void dispose() {
    // Reset orientation back to portrait when leaving the page
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Cancel the ad timer and dispose of any ad resources
    _adTimer?.cancel();
    _interstitialAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
