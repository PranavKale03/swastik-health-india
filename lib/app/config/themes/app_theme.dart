import 'package:flutter/material.dart';
import 'package:swastik_health_india/app/constans/app_constants.dart';

/// all custom application theme
class AppTheme {
  /// default application theme
  static ThemeData get basic => ThemeData(
        fontFamily: Font.poppins,
        primaryColorDark: const Color.fromRGBO(111, 88, 255, 1),
        primaryColor: const Color.fromRGBO(128, 109, 255, 1),
        primaryColorLight: const Color.fromRGBO(159, 84, 252, 1),
        brightness: Brightness.dark,
        // primaryColorBrightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(128, 109, 255, 1),
        ).merge(
          ButtonStyle(elevation: MaterialStateProperty.all(0)),
        )),
        canvasColor: const Color.fromRGBO(31, 29, 44, 1),
        cardColor: const Color.fromRGBO(38, 40, 55, 1),
      );

  /// Light application theme
  static ThemeData get light => ThemeData(
        fontFamily: Font.poppins,
        primaryColorDark: const Color.fromRGBO(111, 88, 255, 1),
        primaryColor: const Color.fromRGBO(128, 109, 255, 1),
        primaryColorLight: const Color.fromRGBO(159, 84, 252, 1),
        brightness: Brightness.light,
        // primaryColorBrightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(128, 109, 255, 1),
        ).merge(
          ButtonStyle(elevation: MaterialStateProperty.all(0)),
        )),
        canvasColor: const Color.fromRGBO(255, 255, 255, 1),
        cardColor: const Color.fromRGBO(255, 255, 255, 1),
      );
}
