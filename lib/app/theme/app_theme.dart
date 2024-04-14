import 'package:crowd_snap/app/theme/color_schemes.dart';
import 'package:flutter/material.dart';
class AppTheme {
  final bool isDarkMode;

  AppTheme({required this.isDarkMode});

  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      colorScheme: isDarkMode ? darkColorScheme : lightColorScheme,
  );
}
