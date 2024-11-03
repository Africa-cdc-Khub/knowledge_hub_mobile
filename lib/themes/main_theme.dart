import 'package:flutter/material.dart';

import 'app_colors.dart';

class MainTheme {
  static final ThemeData defaultTheme = buildTheme(null);
  static const appColors = AppColors();

  late List<Color> primarySwatches;

  static ThemeData buildTheme(Color? primaryColor) {
    return ThemeData(
        fontFamily: 'Ubuntu',
        useMaterial3: true,
        scaffoldBackgroundColor: appColors.white200,
        primaryColor: primaryColor ?? Colors.white,
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w700),
            color: Colors.white),
        buttonTheme: const ButtonThemeData(),
        textTheme: TextTheme(
          bodySmall: TextStyle(
              color: MainTheme.appColors.neutral900,
              fontSize: 12,
              fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(
              color: MainTheme.appColors.neutral900,
              fontSize: 14,
              fontWeight: FontWeight.w400),
          bodyLarge: TextStyle(
              color: MainTheme.appColors.neutral600,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ));
  }

  /// Generates a MaterialColor swatch from a single color.
  MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
