
import 'package:ainxt_digilocker_mod/face_sdk/themefiles/app_colors.dart';
import 'package:ainxt_digilocker_mod/face_sdk/themefiles/text_style.dart';
import 'package:flutter/material.dart';

Widget commonLoading() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const CircularProgressIndicator(
        color: AppColors.primary,
      ),
      Column(
        children: const [
          SizedBox(
            height: 20,
          ),
          Text("Uploading, Please wait ..."),
        ],
      ),
    ],
  );
}

Widget instructionLoading(BuildContext context, double loadingImageOffsetY) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Selfie Tips',
                style: AppTextStyle.headingLarge_20(context)
                    .copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Please remove Spectacles, Hats, Masks. A clearly visible face will get approved test.',
                style: AppTextStyle.bodyLarge_14(context),
              ),
            ],
          ),
        ),
        Expanded(
            flex: 14,
            child: AnimatedContainer(
              duration: const Duration(
                  seconds: 1), // Adjust the animation duration as needed
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(0, loadingImageOffsetY, 0),
              child: Image.asset(
                  'packages/ainxt_digilocker_mod/faceplugin/assets/selfie_preview.png',
                  width: MediaQuery.of(context).size.width * 0.4),
            )),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              footer(context),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ],
    ),
  );
}

AppBar instructionAppBar(BuildContext context) {
  return AppBar(
    backgroundColor:
        AppThemeColors.getColor(AppThemeColorsEnum.background, context),
    elevation: 0,
    leadingWidth: 30,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: AppThemeColors.getColor(AppThemeColorsEnum.invert, context),
      ),
    ),
    title: Text(
      "Phone Camera",
      style: AppTextStyle.headingLarge_20(context).copyWith(
        fontWeight: FontWeight.w400,
        color: AppThemeColors.getColor(AppThemeColorsEnum.invert, context),
      ),
    ),
  );
}

Widget footer(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Powered By ",
        style: AppTextStyle.labelLarge_11(context)
            .copyWith(color:  AppThemeColors.getColor(AppThemeColorsEnum.invert, context)
                 ,),
      ),
      Text(
        "AiNxt.",
        style: AppTextStyle.titleSmall_13(context)
            .copyWith(color: AppThemeColors.getColor(AppThemeColorsEnum.invert, context)),
      ),
      // Image.asset(
      //   "packages/faceplugin/assets/logo.png",
      //   height: 80.sp,
      // ),
    ],
  );
}
