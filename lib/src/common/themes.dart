import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panimithra/src/common/colors.dart';

ThemeData themeLight(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    cardColor: ColorLight.card,
    fontFamily: 'Inter',
    disabledColor: ColorLight.disabledButton,
    // highlightColor: ColorLight.fontTitle,
    hintColor: ColorLight.fontSubtitle,
    indicatorColor: ColorLight.primary,
    iconTheme: const IconThemeData(color: ColorLight.fontTitle),
    primaryColor: ColorLight.primary,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorLight.primary,
    ),
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(color: ColorLight.disabledButton),
    ),
    scaffoldBackgroundColor: ColorLight.background,
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    textTheme: TextTheme(
      displayMedium: TextStyle(
        fontFamily: 'Inter',
        color: ColorLight.fontSubtitle,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Inter',
        color: ColorLight.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        color: ColorLight.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Inter',
        color: ColorLight.fontTitle,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        color: ColorLight.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        color: ColorLight.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        color: ColorLight.fontTitle,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        color: ColorLight.fontSubtitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Inter',
        color: ColorLight.fontSubtitle,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

ThemeData themeDark(BuildContext context) {
  return ThemeData(
    brightness: Brightness.dark,
    cardColor: ColorDark.card,
    disabledColor: ColorDark.disabledButton,
    hintColor: ColorDark.fontSubtitle,
    indicatorColor: ColorLight.primary,
    iconTheme: const IconThemeData(color: ColorDark.fontTitle),
    primaryColor: ColorLight.primary,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorLight.primary,
    ),
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(color: ColorLight.disabledButton),
    ),
    scaffoldBackgroundColor: ColorDark.background,
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
      displayMedium: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      displaySmall: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleLarge: GoogleFonts.poppins(
        color: ColorDark.fontTitle,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: GoogleFonts.poppins(
        color: ColorDark.fontSubtitle,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: GoogleFonts.poppins(
        color: ColorDark.fontSubtitle,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
