// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mythemes {
// theme dark
  static final darkTheme = ThemeData(
    iconTheme: IconThemeData(color: Colors.white),
    fontFamily: GoogleFonts.montserratAlternates().fontFamily,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      // 98, 126, 139
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 52, 74, 84),
      ),
      backgroundColor: Color.fromARGB(255, 52, 74, 84),
    ),
    primaryColor: Color.fromARGB(255, 52, 74, 84),
  );

// theme light
  static final lightTheme = ThemeData(
    fontFamily: GoogleFonts.montserratAlternates().fontFamily,
    iconTheme: IconThemeData(color: Colors.white),
    highlightColor: Color.fromARGB(255, 168, 168, 169),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 13, 105, 139),
      ),
      backgroundColor: Color.fromARGB(255, 13, 105, 139),
    ),
    primaryColor: Color.fromARGB(255, 13, 105, 139),
  );
}

// themeprovider for change the togle button
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  ThemeProvider(bool isDark) {
    if (isDark) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
  }
  void toggleTheme(bool isOn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    if (isOn == true) {
      themeMode = ThemeMode.dark;
      sharedPreferences.setBool('is_dark', true);
    } else {
      themeMode = ThemeMode.light;
      sharedPreferences.setBool('is_dark', false);
    }
    notifyListeners();
  }
}
