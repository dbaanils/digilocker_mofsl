//dark_theme.dart
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primary,
    primaryColorDark: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    dialogBackgroundColor: AppColors.backgroundDark,
    //fontFamily: 'be_vietnam_pro',
    fontFamily: 'Barlow',
    primaryTextTheme: TextTheme(
      headlineLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      headlineMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      headlineSmall: TextStyle(
        letterSpacing: 0,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      titleLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      titleMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      titleSmall: TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      bodyLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      bodyMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      bodySmall: TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      labelLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      labelMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      labelSmall: TextStyle(
        letterSpacing: 0,
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
    ),

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.whiteColor,
      ),
      headlineMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.whiteColor,
      ),
      headlineSmall: TextStyle(
        letterSpacing: 0,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.whiteColor,
      ),
      titleLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.whiteColor,
      ),
      titleMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.whiteColor,
      ),
      titleSmall: TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.whiteColor,
      ),
      bodyLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.whiteColor,
      ),
      bodyMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.whiteColor,
      ),
      bodySmall: TextStyle(
        letterSpacing: 0,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.whiteColor,
      ),
      labelLarge: TextStyle(
        letterSpacing: 0,
        fontSize: 11,
        fontWeight: FontWeight.w300,
        color: AppColors.whiteColor,
      ),
      labelMedium: TextStyle(
        letterSpacing: 0,
        fontSize: 10,
        fontWeight: FontWeight.w300,
        color: AppColors.whiteColor,
      ),
      labelSmall: TextStyle(
        letterSpacing: 0,
        fontSize: 9,
        fontWeight: FontWeight.w300,
        color: AppColors.whiteColor,
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.backgroundDark,
      elevation: 0.0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      //contentPadding: const EdgeInsets.only(bottom: 3),
      labelStyle: TextStyle(
        //height: 0.6,
        letterSpacing: 0,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.whiteColor,
      ),
      fillColor: AppColors.backgroundDark,
      isDense: true,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.whiteColor,
          width: 1,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1,
        ),
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: AppColors.primary,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.whiteColor,
    ),
    dividerColor: AppColors.divider,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      focusColor: Colors.white,
      height: 60,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.primary))),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.backgroundDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.backgroundDark,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.backgroundDark),
  );
}
