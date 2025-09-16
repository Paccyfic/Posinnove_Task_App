import 'package:flutter/material.dart';

class MyTheme {
  static const splash =  Color(0xFF303030); // equivalent to Colors.grey[850]
  static const statusBar = Color(0xFF2E3147);
  static const appBarColor = Color(0xFF222539);
  static const greenColor = Color(0xFF2EC492);
  static const orangeColor = Color(0xFFEB8D2F);
  static const greyColor = Color(0xFFF4F4F4);
  static const blueBorder = Color(0xFF3164CE);
  static const redBorder = Color(0xFFF14336);
  static const redLight = Color(0xFFFFF1F0);
  static const blueLight = Color(0xFFF5F9FF);
  static List<Color> redGiftGradientColors = [
    const Color(0xFFFCCAC6).withOpacity(0.3),
    const Color(0xFFDB5449).withOpacity(0.3),
  ];
  static List<Color> greenGiftGradientColors = [
    const Color(0xFF89D980).withOpacity(0.3),
    const Color(0xFF34BA25).withOpacity(0.3),
  ];
  static const redTextColor = Color(0xFFD05045);
  static const greenTextColor = Color(0xFF8CC153);

  static final myLightTheme = ThemeData(
    primaryColor: Color(0xFF303030),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      titleMedium: TextStyle(color: Colors.white.withOpacity(0.7), inherit: true),
    ),
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme.light(
        surface: splash,
        primary: Color(0xFF303030),
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: appBarColor,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF303030),
      onPrimary: Colors.white,
      secondary: greenColor,
      onSecondary: Colors.white,
      error: redBorder,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

  static final myDarkTheme = ThemeData(
    primaryColor: Color(0xFF303030),
    scaffoldBackgroundColor: appBarColor,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme.dark(
        surface: splash,
        primary: splash,
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: appBarColor,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: splash,
      onPrimary: Colors.white,
      secondary: greenColor,
      onSecondary: Colors.black,
      error: redBorder,
      onError: Colors.white,
      surface: appBarColor,
      onSurface: Colors.white,
    ),
  );
}