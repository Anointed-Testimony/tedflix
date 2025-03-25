import 'package:flutter/material.dart';
import 'package:tedflix_app/common/screenutil/screenutil.dart';
import 'package:tedflix_app/presentation/journeys/home/home_screen.dart';
import 'package:tedflix_app/presentation/themes/theme_color.dart';
import 'package:tedflix_app/presentation/themes/theme_text.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tedflix_app/presentation/widgets/banner_ad_widget.dart';
import 'package:tedflix_app/presentation/widgets/inter_ads_widget.dart'; // Import AdMob package

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TedFlix',
      theme: ThemeData(
        primaryColor: AppColor.vulcan,
        scaffoldBackgroundColor: AppColor.vulcan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeText.getTextTheme(),
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: HomeScreen(), // Your main screen content
            ),
          ],
        ),
      ),
    );
  }
}