
import 'package:ainxt_digilocker_mod/face_sdk/themefiles/app_colors.dart';
import 'package:ainxt_digilocker_mod/face_sdk/themefiles/text_style.dart';
import 'package:flutter/material.dart';

Widget successMessageScreenTop(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 12, right: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Congratulations",
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyLarge_14(context)
              .copyWith(color: AppColors.whiteColor, fontSize: 24),
        ),
        SizedBox(
          width: 20,
        ),
        Icon(
          Icons.thumb_up_alt_outlined,
          color: AppColors.success,
        )
      ],
    ),
  );
}

Widget successMessageScreen(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        textAlign: TextAlign.center,
        "Face Analysis Successful",
        style: AppTextStyle.bodyLarge_14(context).copyWith(
          color: AppColors.success,
          fontSize: 18, //0.ssp,
        ),
      ),
      SizedBox(
        height: 15, //.sp,
      ),
      Image.asset('packages/ainxt_digilocker_mod/faceplugin/assets/success.gif',
          width: MediaQuery.of(context).size.width * 0.15), //.w),
      // Text(
      //     textAlign: TextAlign.center,
      //     "For successful submission of your selfie capture, In 3 seconds you will be redirected to your opening journey"),
      SizedBox(
        height: 10,
      ),
      // ElevatedButton(
      //   onPressed: () {
      //     widget.success(unique_id);
      //   },
      //   style: OutlinedButton.styleFrom(
      //     backgroundColor: const Color(0xFFef4f28),
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(20)),
      //   ),
      //   child: const Text(
      //     "Continue",
      //   ),
      // ),
    ],
  );
}

Widget failedMessageScreen(BuildContext context,
    {required String failedMessage, required void Function()? onPressed}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(height: 4),
      Text(
          textAlign: TextAlign.center,
          failedMessage,
          style: AppTextStyle.bodyLarge_14(context).copyWith(
            color: AppColors.errorAccent,
            fontSize: 18, //0.ssp,
          )),

      const SizedBox(height: 10),
      Image.asset('packages/ainxt_digilocker_mod/faceplugin/assets/failed.gif',
          width: MediaQuery.of(context).size.width * 0.15), //.w),
      const SizedBox(height: 5),
      ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            "Retry",
            style: AppTextStyle.subtitleLarge_14(context)
                .copyWith(color: AppColors.backgroundLight),
          )),
    ],
  );
}

Widget cameraScreenFooter(BuildContext context,
    {required void Function()? onTap,
    required bool hasFace,
    required bool isTooClose,
    required bool isTooFar}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        height: MediaQuery.of(context).size.width / 6, //.sp,
        width: MediaQuery.of(context).size.width / 6, //.sp,

        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 3, //.sp,
              color: hasFace && !isTooClose && !isTooFar
                  ? AppThemeColors.getColor(AppThemeColorsEnum.active, context)
                  : AppThemeColors.getColor(
                      AppThemeColorsEnum.inactive, context),
              // _hasFace && !_isTooClose && !_isTooFar
              //     ? Colors.green
              //     : Colors.red
            )),
        child: InkWell(
          radius: 100,
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child: Icon(
            Icons.camera,
            size: MediaQuery.of(context).size.width / 7,
            color: hasFace && !isTooClose && !isTooFar
                ? AppThemeColors.getColor(AppThemeColorsEnum.active, context)
                : AppThemeColors.getColor(AppThemeColorsEnum.inactive, context),
          ),
        ),
      ),
    ],
  );
}
