import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const THEME_STATUS = "THEME_STATUS";
  bool darkTheme = false;
  bool get getIsDarkTheme => darkTheme;

  ThemeProvider() {
    getTheme();
  }

  setDarkTheme({required bool themValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(THEME_STATUS, themValue);
    darkTheme = themValue;
    notifyListeners();
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    darkTheme = prefs.getBool(THEME_STATUS) ?? false;
    notifyListeners();
    return darkTheme;
  }
}
