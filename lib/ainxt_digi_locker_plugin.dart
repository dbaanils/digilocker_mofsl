import 'package:flutter/material.dart';
import 'screens/digi_locker_screen.dart';

class AinxtDigilockerPlugin {
  AiNxtDigiLockerPlugin() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<dynamic> init(
    BuildContext context,
    String platform,
    String sdkAppBarTitle,
    String redirectURL,
    String redirectURLHost,
    String secretKey,
  ) async {
    //Open a modal dialog from bottom of the screen
    return await showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0.0))),
      enableDrag: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      isDismissible: false,
      useRootNavigator: true,
      context: (context),
      builder: (context) {
        return Padding(
            padding: EdgeInsets.only(
                top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .padding
                    .top),
            child: getWidget(context, platform, sdkAppBarTitle, redirectURL,
                redirectURLHost, secretKey));
      },
    );
  }

  Widget? getWidget(
    BuildContext context,
    String? platform,
    String? sdkAppBarTitle,
    String? redirectURL,
    String? redirectURLHost,
    String? secretKey,
  ) {
    Widget? localWidget;

    /*if(Platform.isIOS){
      // Commented becoz size is increasing for Android APK
        localWidget = DigiLockerScreen(
        platform: widget.platform!,
        sdkAppBarTitle: widget.sdkAppBarTitle!,
        redirectURL: widget.redirectURL!,
        redirectURLHost: widget.redirectURLHost!,
        secretKey: widget.secretKey!,
        onCompletion: (String? accessRequestId) {
          Navigator.pop(context, accessRequestId);
        },);
    }else{
      localWidget = AinxtDigiLockerSDKScreen(
        platform: widget.platform!,
        sdkAppBarTitle: widget.sdkAppBarTitle!,
        redirectURL: widget.redirectURL!,
        redirectURLHost: widget.redirectURLHost!,
        secretKey: widget.secretKey!,
        onCompletion: (String? accessRequestId) {
          Navigator.pop(context, accessRequestId);
        },
      );
    }*/

    localWidget = DigiLockerScreen(
      platform: platform,
      sdkAppBarTitle: sdkAppBarTitle!,
      redirectURL: redirectURL!,
      redirectURLHost: redirectURLHost!,
      secretKey: secretKey!,
      onCompletion: (BuildContext context, String? accessRequestId) {
        Navigator.pop(context, accessRequestId);
      },
    );

    return localWidget;
  }
}
