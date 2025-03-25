import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';  // For platform check

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // Replace with your Ad Unit IDs for Android and iOS
  final adUnitId = Platform.isAndroid
    ? 'ca-app-pub-8360591759937694/4205897028'
    : 'ca-app-pub-3940256099942544/2934735716';// iOS Ad Unit ID

  @override
  void initState() {
    super.initState();
    loadBannerAd();
  }

  // Method to load the banner ad
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isLoaded = true;
          });
          debugPrint('Banner ad loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Load the banner ad
    _bannerAd!.load();
  }

  @override
  void dispose() {
    // Dispose of the ad when the widget is disposed
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Container(
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : Container();  // Return an empty container if ad is not loaded
  }
}
