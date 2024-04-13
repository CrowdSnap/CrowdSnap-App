import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0D47A1);

class AppTheme {
  final bool isDarkMode;

  AppTheme({required this.isDarkMode});

  ThemeData getTheme() => ThemeData (
    useMaterial3: true,
    colorSchemeSeed: primaryColor,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,

    listTileTheme: const ListTileThemeData(
      iconColor: primaryColor
    )

  );  
}