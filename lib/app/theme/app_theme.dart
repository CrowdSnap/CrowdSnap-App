import 'package:crowd_snap/app/theme/color_schemes.dart';
import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;

  AppTheme({required this.isDarkMode});

  ThemeData getTheme() {
    final colorScheme = isDarkMode ? darkColorScheme : lightColorScheme;
    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceDim,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.inverseSurface, // Color del texto
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: colorScheme.tertiary,
        backgroundColor: colorScheme.surface,
      )
    );
  }
}
