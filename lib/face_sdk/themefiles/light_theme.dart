//light_theme.dart
// ignore_for_file: constant_identifier_names


import 'package:flutter/material.dart';

import 'app_colors.dart';

const Color APP_LIGHT_PRIMARY_COLOR = Color(0xFF171efd);
const Color APP_PRIMARY_TEXT_COLOR = Color(0xFF171efd);

// Text Theme
const Color APP_TEXT_COLOR = Color(0xFF41414E);
const Color APP_LIGHT_TEXT_COLOR = Color(0xFF7A7A7A);

// Accent Text Theme
const Color APP_ACCENT_TEXT_COLOR = Color(0xFF002953);
const Color APP_LIGHT_ACCENT_TEXT_COLOR = Color(0xFFFFFFFF);

Color hexToColor(String code) =>
    Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);

ThemeData lightTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primary,
      primaryColorDark: APP_LIGHT_PRIMARY_COLOR,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      dialogBackgroundColor: AppColors.backgroundLight,
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
          color: AppColors.textMedium,
        ),
        headlineMedium: TextStyle(
          letterSpacing: 0,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textMedium,
        ),
        headlineSmall: TextStyle(
          letterSpacing: 0,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textMedium,
        ),
        titleLarge: TextStyle(
          letterSpacing: 0,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: APP_TEXT_COLOR,
        ),
        titleMedium: TextStyle(
          letterSpacing: 0,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: APP_TEXT_COLOR,
        ),
        titleSmall: TextStyle(
          letterSpacing: 0,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: APP_TEXT_COLOR,
        ),
        bodyLarge: TextStyle(
          letterSpacing: 0,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: APP_TEXT_COLOR,
        ),
        bodyMedium: TextStyle(
          letterSpacing: 0,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: APP_TEXT_COLOR,
        ),
        bodySmall: TextStyle(
          letterSpacing: 0,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: APP_TEXT_COLOR,
        ),
        labelLarge: TextStyle(
          letterSpacing: 0,
          fontSize: 11,
          fontWeight: FontWeight.w300,
          color: APP_TEXT_COLOR,
        ),
        labelMedium: TextStyle(
          letterSpacing: 0,
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: APP_TEXT_COLOR,
        ),
        labelSmall: TextStyle(
          letterSpacing: 0,
          fontSize: 9,
          fontWeight: FontWeight.w300,
          color: APP_TEXT_COLOR,
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: AppColors.backgroundLight,
        elevation: 0.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        //contentPadding: const EdgeInsets.only(bottom: 3),
        labelStyle: TextStyle(
          //height: 0.6,
          letterSpacing: 0,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.textMedium,
        ),
        fillColor: AppColors.loadingBackground,
        isDense: true,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
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
        color: AppColors.textMedium,
      ),
      dividerColor: AppColors.divider,
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusColor: Colors.black,
        height: 60,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.primary))),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.primary,
      ),
      bottomAppBarTheme:
          const BottomAppBarTheme(color: AppColors.backgroundLight),
      tabBarTheme: TabBarTheme(
          labelStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelColor: AppColors.unselectedTextLight,
          labelColor: AppColors.blackColor,
          unselectedLabelStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          )));
}

class AppColours {
  static bool isDarkMode = false;
  static const String blue_selected_border = "selected_color";
  static const String grey_unSelected_border = "unselected_color";
  static const String buttonEnble = "button_enable_color";
  static const String buttonDisable = "button_disable_color";
  static const String blue_TextColor = "blue_TextColor";
  static const String grey_Background = "gray_background";
  static const String grey_TextColor = "grey_TextColor";
  static const String black_TextColor = "black_TextColor";
  static const String textField_Fillcolor = "textField_Fillcolor";
  static const String error_RedColor = "errorMsg_color";
  static const String grey1_TextColor = "grey1_TextColor";
  static const String red_TextColor = "red_TextColor";
  static const String green_TextColor = "green_TextColor";

  static var colours = {
    black_TextColor: {
      "light": 0xFF41414E,
      "dark": 0xFF41414E,
    },
    grey1_TextColor: {
      "light": 0xFF989898,
      "dark": 0xFF989898,
    },
    red_TextColor: {
      "light": 0xFFdd2006,
      "dark": 0xFFdd2006,
    },
    green_TextColor: {
      "light": 0xFF2bb02b,
      "dark": 0xFF2bb02b,
    },
    blue_selected_border: {
      "light": 0xff0559ff,
      "dark": 0xff0559ff,
    },
    grey_unSelected_border: {
      "light": 0xffdddddd,
      "dark": 0xffdddddd,
    },
    buttonEnble: {
      "light": 0xff0559ff,
      "dark": 0xff0559ff,
    },
    buttonDisable: {
      "light": 0xff7a7a7a,
      "dark": 0xff7a7a7a,
    },
    blue_TextColor: {
      "light": 0xFF0559ff,
      "dark": 0xFF0559ff,
    },
    grey_TextColor: {
      "light": 0xff7a7a7a,
      "dark": 0xff7a7a7a,
    },
    grey_Background: {
      "light": 0xffefefef,
      "dark": 0xffefefef,
    },
    textField_Fillcolor: {
      "light": 0x80efefef,
      "dark": 0x80efefef,
    },
    error_RedColor: {
      "light": 0xFF0000,
      "dark": 0xFF0000,
    },
  };

  static Color getColour(String colourName) {
    return (isDarkMode)
        ? Color(colours[colourName]!["dark"]!)
        : Color(colours[colourName]!["light"]!);
  }
}
