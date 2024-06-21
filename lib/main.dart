import 'package:ainxt_digilocker_mod/constants/app_constants.dart';
import 'package:ainxt_digilocker_mod/screens/digi_locker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? sdkAppBarTitle;
  String? redirectURL;
  String? redirectURLHost;
  String? platform;
  String? secretKey;

  final methodChannel = MethodChannel(AppConstants.FLUTTER_CHANNEL_ID);

  // methodChannel.setMethodCallHandler((call) async {
  //   var jData;
  //
  //   try {
  //     if (call.method == "getAccessRequestId") {
  //       final String data = call.arguments;
  //       jData = await jsonDecode(data);
  //     }
  //   } on PlatformException catch (error) {
  //     print('error in MAIN CATCH Line:30 $error');
  //   }
  //
  //   platform = jData['platform'];
  //   sdkAppBarTitle = jData['sdkAppBarTitle'];
  //   redirectURL = jData['redirectURL'];
  //   redirectURLHost = jData['redirectURLHost'];
  //   secretKey = jData['secretKey'];
  //
  //   AppUtils.printLog('Platform from HOST: $platform');
  //
  //   runApp(MyApp(
  //       platform, sdkAppBarTitle, redirectURL, redirectURLHost, secretKey));
  // });
//  Below code is for testing
  platform = "IOS";
  sdkAppBarTitle = "MAIN.dart";
  redirectURL = "https://main.d21iupo02d286g.amplifyapp.com/digilocker";
  redirectURLHost = "main.d21iupo02d286g.amplifyapp.com";
  secretKey = "B05E05BCD9C50E49870468D4617E25FA";

  // Forgot to comment this line when i have given repo to MOFSL on 21-July-2023
  runApp(
      MyApp(platform, sdkAppBarTitle, redirectURL, redirectURLHost, secretKey));
}

class MyApp extends StatefulWidget {
  String? sdkAppBarTitle;
  String? redirectURL;
  String? redirectURLHost;
  String? platform;
  String? secretKey;

  MyApp(this.platform, this.sdkAppBarTitle, this.redirectURL,
      this.redirectURLHost, this.secretKey,
      {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        child: getWidget() ?? const SizedBox(),
      ),
    );
  }

  Widget? getWidget() {
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
      platform: widget.platform!,
      sdkAppBarTitle: widget.sdkAppBarTitle!,
      redirectURL: widget.redirectURL!,
      redirectURLHost: widget.redirectURLHost!,
      secretKey: widget.secretKey!,
      onCompletion: (String? accessRequestId) {
        Navigator.pop(context, accessRequestId);
      },
    );

    return localWidget;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: ElevatedButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => widget.child,
              isScrollControlled: true,
            ),
            child: Text("Start"),
          ),
        ),
      );
}
