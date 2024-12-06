import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 7, 25, 61);
  static const Color secondaryColor = Color.fromARGB(255, 8, 102, 255);

  static const String fontFamily = 'Inter';
  static const Color bodyTextColor1 = Color.fromARGB(255, 5, 5, 5);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
        primary: primaryColor, secondary: secondaryColor),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: primaryColor),
      displayMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: primaryColor),
      titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: bodyTextColor1),
      titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: bodyTextColor1),
      bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: bodyTextColor1),
      bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: bodyTextColor1),
      bodySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: bodyTextColor1),
    ),
    fontFamily: fontFamily,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
        primary: primaryColor, secondary: secondaryColor),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: primaryColor),
      displayMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: primaryColor),
      titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: bodyTextColor1),
      titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: bodyTextColor1),
      bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: bodyTextColor1),
      bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: bodyTextColor1),
      bodySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: bodyTextColor1),
    ),
    fontFamily: fontFamily,
  );
}
