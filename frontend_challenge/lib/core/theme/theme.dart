import 'package:flutter/material.dart';
import 'package:frontend_challenge/core/theme/app_pallete.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightThemeMode = ThemeData.from(
    useMaterial3: true,
    textTheme: GoogleFonts.dmSansTextTheme(),
    colorScheme: ColorScheme.fromSeed(
            seedColor: Pallete.primaryColor, brightness: Brightness.light)
        .copyWith(
      surface: Pallete.whiteColor,
    ),
  ).copyWith(
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.zero,
      border: UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(),
      focusedBorder: UnderlineInputBorder(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Pallete.backgroundColor,
    ),
  );
}

extension ThemeDataExtension on ThemeData {
  ButtonStyle get elevatedBlackPill => ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        foregroundColor: Pallete.whiteColor,
        textStyle: textTheme.bodyLarge
            ?.copyWith(fontWeight: FontWeight.w500, fontSize: 20),
        elevation: 0,
        backgroundColor: Pallete.blackColor,
        shape: const StadiumBorder(),
      );
}
