import 'package:flutter/material.dart';

const typeTheme = Typography.whiteMountainView;

class ThemeProvider {
  static const appColor = Color(0xFFF3CB8E);
  static Color blackColor = const Color(0xFF303030);
  static Color primary = const Color(0xFF213198);
  static Color buttonColor = const Color(0xFF1552EF);
  static Color buttonColor1 = const Color(0xFF0000FF);
  static Color buttonBack = const Color(0xFFFAFAFC);
  static Color fieldColor = const Color(0xFF404143);
  // static Color textColor = const Color(0xFF202124);
  static Color textColor = Colors.white;
  static Color greyColor = const Color(0xFF808080);
  static Color greyColor1 = const Color(0xFFF7F7F7);
  static Color redColor = const Color(0xFFC11119);
  static Color redColor2 = const Color(0xFFF8C9DA);
  static Color redColor1 = const Color(0xFFFFC5CB);
  static Color lightThemeBgColor1 = const Color(0xFFEFF2FC);
  static Color lightThemeBgColor2 = const Color(0xFFCADDFA);

  static const secondaryAppColor = Color(0xFF0C25AE);
  static const whiteColor = Colors.white;
  static const titleStyle = TextStyle(fontFamily: 'bold', fontSize: 14, color: ThemeProvider.whiteColor);
}

TextTheme txtTheme = Typography.whiteMountainView.copyWith(
  bodyLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  bodyMedium: typeTheme.bodyLarge?.copyWith(fontSize: 14),
  displayLarge: typeTheme.bodyLarge?.copyWith(fontSize: 32),
  displayMedium: typeTheme.bodyLarge?.copyWith(fontSize: 28),
  displaySmall: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  headlineMedium: typeTheme.bodyLarge?.copyWith(fontSize: 21),
  headlineSmall: typeTheme.bodyLarge?.copyWith(fontSize: 18),
  titleLarge: typeTheme.bodyLarge?.copyWith(fontSize: 16),
  titleMedium: typeTheme.bodyLarge?.copyWith(fontSize: 24),
  titleSmall: typeTheme.bodyLarge?.copyWith(fontSize: 21),
);

class AppThemes {
  static final light = ThemeData(
      brightness: Brightness.light,
      cardColor: ThemeProvider.whiteColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black), // General text color
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.black54),
        titleLarge: TextStyle(color: Colors.blue), // Example for headings
      ),
      appBarTheme: AppBarTheme(color: ThemeProvider.whiteColor),
      scaffoldBackgroundColor: Colors.grey.shade300);

  static final dark = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      cardColor: ThemeProvider.blackColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white), // General text color
        bodyMedium: TextStyle(color: Colors.white38),
        bodySmall: TextStyle(color: Colors.white24),
        titleLarge: TextStyle(color: Colors.white24), // Example for headings
      ),
      appBarTheme: AppBarTheme(color: ThemeProvider.blackColor),
      scaffoldBackgroundColor: ThemeProvider.blackColor);
}
