import 'package:flutter/material.dart';

class AppColors {
//New ColorCode  -----Asang
  static const Color primary = Color(0xff7145BF);
  static const Color primaryVarient = Color(0xff0559ff);
  static const Color primaryLint = Color(0xffF5F5F5);
  static Color primaryVarientLight = const Color(0xff0559ff).withOpacity(0.05);

  // static Color background =
  //     AppThemeColors.getColor(AppThemeColorsEnum.background);
 

  static const Color backgroundLight = Color(0xffFFFFFF);
  static const Color backgroundDark = Color(0xff1B1B1B);
  static const Color backgroundDarkVarient = Color(0xff33253E);
  static const Color backgroundDarkVarient2 = Color(0xff1B0F25);

  static const Color transparent = Colors.transparent;

  static const Color blackColor = Color(0xFF333333);
  static const Color blackPure = Color(0xFF000000);
  static const Color whiteColor = Color(0xFFFFFFFF);

  static const Color errorAccent = Color(0xFFFF5252);

  static const Color textFieldBorderColor = Color(0x66171efd);

  static const Color fail = Color(0xffDD2006);
  static const Color success = Color(0xff2BB02B);
  static Color profitLint = const Color(0xff2BB02B).withOpacity(0.05);

  static Color dividerDark = const Color(0xff969BA1).withOpacity(0.3);
  static Color divider = const Color(0xff969BA1).withOpacity(0.2);
  static Color dividerLight = const Color(0xff969BA1).withOpacity(0.1);

  static const Color grayLight = Color(0xffF5F5F5);
  static const Color grayMedium = Color(0xffE0E0E0);
  static const Color grayDark = Color(0xff989898);

  static const Color yellowLight = Color(0xffFFEFCF);
  static const Color yellowMedium = Color(0xffFFE96B);
  static const Color yellowDark = Color(0xffFDC259);

  static const Color cyanLight = Color(0xffE1F3FC);
  static const Color cyanMedium = Color(0xff91D5E2);
  static const Color cyanDark = Color(0xff52BDE2);

  static const Color greenDark = Color(0xff60C2AC);
  static const Color greenMedium = Color(0xffCBE6D2);
  static const Color greenLight = Color(0xffE3F1E6);

  static const Color brandPrimaryShade1 = Color(0xffED0C6E);
  static const Color brandPrimaryShade2 = Color(0xffED0C6E);
  static const Color brandPrimaryShade3 = Color(0xffED0C6E);
  static const Color brandPurple = Color(0xff812990);
  static const Color brandOrange = Color(0xfff37021);
  static const Color brandOrangeMedium = Color(0xFFFF8800);
  static const Color brandGreenMedium = Color(0xFF0bac68);

  static const Color primaryText = Color(0xff171EFD);

  static const Color textLight = Color(0xff959595);
  static const Color textMedium = Color(0xff41414E);
  static const Color textMedium2 = Color(0xff777777);
  static const Color unselectedTextLight = Color(0xFF7a7a7a);
  static const Color loadingBackground = Color(0xFFE8E9ED);

  static const Color border = Color(0xffdddddd);
  static const Color borderDark = Color(0x33969ba1);
  static const Color borderBlackColor = Color(0x33969ba1); //copy of borderDark

  static LinearGradient primaryGradient = const LinearGradient(
    colors: [
      Color(0xffED0C6E),
      Color(0xffEF414A),
      Color(0xffF37021),
    ],
  );
  static LinearGradient secondaryGradient = const LinearGradient(
    colors: [
      Color(0xffED0C6E),
      Color(0xffEF414A),
      Color(0xffF37021),
      Color(0xff812990),
    ],
  );
}

//Light Dark Theme Colors Class  ------Asang

class AppThemeColors {
  static List<Color> lightColors = const [
    AppColors.backgroundLight, //background
    AppColors.backgroundDark, //invert
    AppColors.blackColor, //active
    AppColors.textLight, //inactive
  ];
  static List<Color> darkColors = const [
    AppColors.backgroundDark, //background
    AppColors.backgroundLight, //invert
    AppColors.backgroundLight, //active
    AppColors.blackColor, //inactive
  ];

  //function to get any color with light dark theme
  static Color getColor(AppThemeColorsEnum color, BuildContext context) {
    //picking context from main.dart

    return (Theme.of(context).brightness) == Brightness.light
        ? lightColors[color.index]
        : darkColors[color.index];
  }

  //function to get single color
  static Color getSingleColor(AppThemeColorsEnum color, {bool isDark = false}) {
    return isDark ? darkColors[color.index] : lightColors[color.index];
  }
}

enum AppThemeColorsEnum { background, invert, active, inactive }
