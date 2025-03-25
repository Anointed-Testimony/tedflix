import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/presentation/themes/theme_color.dart';

class ThemeText {
  const ThemeText._();

  static TextTheme get _poppinsTextTheme => GoogleFonts.poppinsTextTheme();

  static TextStyle get _whiteHeadline6 => _poppinsTextTheme.titleLarge!.copyWith(
        fontSize: Sizes.dimen_20.sp.toDouble(),
        color: Colors.white,
      );

  static TextStyle get whiteSubtitle1 => _poppinsTextTheme.titleMedium!.copyWith(
        fontSize: Sizes.dimen_16.sp.toDouble(),
        color: Colors.white,
      );

  static TextStyle get whiteBodyText2 => _poppinsTextTheme.bodyMedium!.copyWith(
        color: Colors.white,
        fontSize: Sizes.dimen_14.sp.toDouble(),
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextTheme getTextTheme() => TextTheme(
        titleLarge: _whiteHeadline6,
        bodyMedium: whiteBodyText2,
        titleMedium: whiteSubtitle1,
      );
}

extension ThemeTextExtension on TextTheme {
  TextStyle get royalBlueSubtitle1 => titleMedium!.copyWith(
        color: AppColor.royalBlue,
        fontWeight: FontWeight.w600,
      );

  TextStyle get greySubtitle1 => bodyLarge!.copyWith(
        color: Colors.grey,
      );

  TextStyle get violetHeadline6 => titleLarge!.copyWith(
        color: AppColor.violet,
      );
  TextStyle get vulcanBodyText2 => bodyMedium!.copyWith(
      color: AppColor.vulcan,
      fontWeight: FontWeight.w600,
    );
}
