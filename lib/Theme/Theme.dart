import 'dart:ui';
import 'package:flutter/material.dart';

class LightTheme {
  // Light Theme Colors
  static final backgroundColors = Color(0xFFFFFFFF);
  static final primaryColors = Color(0xFFA884FF);
  static final titleColors = Color(0xFF26364D);
  static final subTitleColors = Color(0xFF6B7280);
  static final _statsBgColor = Color(0xFFB599FF);
  static final linnerColors = LinearGradient(
    colors: [
      Color(0xFFCCBBFF),
      Color(0xFFA25DFF),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Lato',
    primaryColor: primaryColors,
    scaffoldBackgroundColor: backgroundColors,
    textTheme: TextTheme(
      displayLarge: TextStyle(color: titleColors, fontFamily: 'Lato'),
      displayMedium: TextStyle(color: titleColors, fontFamily: 'Lato'),
      displaySmall: TextStyle(color: titleColors, fontFamily: 'Lato'),
      headlineMedium: TextStyle(color: titleColors, fontFamily: 'Lato'),
      headlineSmall: TextStyle(color: titleColors, fontFamily: 'Lato'),
      titleLarge: TextStyle(color: titleColors, fontFamily: 'Lato'),
      bodyLarge: TextStyle(color: subTitleColors, fontFamily: 'Lato'),
      bodyMedium: TextStyle(color: subTitleColors, fontFamily: 'Lato'),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Lato',
    primaryColor: primaryColors,
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontFamily: 'Lato'),
      displayMedium: TextStyle(color: Colors.white, fontFamily: 'Lato'),
      displaySmall: TextStyle(color: Colors.white, fontFamily: 'Lato'),
      headlineMedium: TextStyle(color: Colors.white, fontFamily: 'Lato'),
      headlineSmall: TextStyle(color: Colors.white, fontFamily: 'Lato'),
      titleLarge: TextStyle(color: Colors.white, fontFamily: 'Lato'),
      bodyLarge: TextStyle(color: Colors.white70, fontFamily: 'Lato'),
      bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Lato'),
    ),
  );
}
