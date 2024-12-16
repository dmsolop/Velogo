import 'package:flutter/material.dart';
import 'base_colors.dart';

class BaseFonts {
  static const String primaryFont = 'Roboto';

  // Існуючі шрифти
  static const TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: BaseColors.textPrimary,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: BaseColors.textPrimary,
  );

  static const TextStyle subHeadline = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: BaseColors.textPrimary,
  );

  // Нові шрифти для MainScreen
  static const TextStyle bodyTextLight = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: BaseColors.textSecondary,
  );

  static const TextStyle bodyTextBold = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: BaseColors.textPrimary,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: BaseColors.textPrimary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: BaseColors.textPrimary,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: BaseColors.textPrimary,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: BaseColors.textPrimary,
  );
}
