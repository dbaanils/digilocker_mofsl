import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../constants/app_constants.dart';
import '../constants/url_constants.dart';
import '../models/gen_url_response_token.dart';
import '../utils/app_utils.dart';

class DigiLockerScreen extends StatefulWidget {
  String? platform;
  String? redirectURL;
  String? redirectURLHost;
  String? sdkAppBarTitle;
  String? secretKey;
  Function onCompletion;

  DigiLockerScreen(
      {Key? key,
      required this.platform,
      required this.sdkAppBarTitle,
      required this.redirectURL,
      required this.redirectURLHost,
      required this.secretKey,
      required this.onCompletion})
      : super(key: key);

  @override
  State<DigiLockerScreen> createState() => _DigiLockerScreenState();
}

class _DigiLockerScreenState extends State<DigiLockerScreen> {
  late final WebViewController _controller;

  GenUrlResponseToken? genUrlResponseToken;
  bool isUploading = false;
  String? digiLockerURL;
  String? errorMsg;
  final methodChannel = MethodChannel(AppConstants.FLUTTER_CHANNEL_ID);
  String? accessIdData;

  @override
  void dispose() {
    _controller.clearCache();
    _controller.clearLocalStorage();
    AppUtils.printLog("DISPOSE CALLED");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('Clear old data in init');
    accessIdData = null;

    String redirectURLHost = widget.redirectURLHost!;

    /*late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }*/

    PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(
        params,
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams
          .fromPlatformWebViewControllerCreationParams(
        params,
      );
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      // _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            AppUtils.printLog('progress: $progress');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String URL) {
            Uri url = Uri.parse(URL);
            AppUtils.printLog("URL: $url");
            AppUtils.printLog("URL HOST: ${url.host.toString()}");
            AppUtils.printLog("redirectURLHost: $redirectURLHost");
            if (url.host.contains(redirectURLHost) &&
                url.toString().contains('accessRequestId')) {
              AppUtils.printLog("Return URL: $url");
              var uri =
                  Uri.dataFromString(url.toString()); //converts string to a uri
              Map<String, String> params = uri
                  .queryParameters; // query parameters automatically populated
              var accessRequestId = params[
                  'accessRequestId']; // return value of parameter "param1" from uri
              AppUtils.printLog("accessRequestId: $accessRequestId");
              //  widget.onCompletion(accessRequestId);
              finishModuleWithData(accessRequestId);
              return;
            } else if (url.toString().contains("m")) {
              var uri =
                  Uri.dataFromString(url.toString()); //converts string to a uri
              Map<String, String> params = uri
                  .queryParameters; // query parameters automatically populated
              var error =
                  params['m']; // return value of parameter "param1" from uri
              AppUtils.printLog("ERROR MESSAGE M: $error");
              if (error != null) {
                // widget.onCompletion(error);
                finishModuleWithData(error);
              }
              return;
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      );
    genDLUrl();
    // ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  bool pop = false;

  Future<void> finishModuleWithData(String? data) async {
    if (!pop) {
      if (widget.platform == "ANDROID" || widget.platform == "IOS") {
        AppUtils.printLog("CAME INSIDE FINISH: ${widget.platform}");
        // SystemNavigator.pop(); /* this was popping data 2 times*/
        Navigator.pop(context);
        setState(() => pop = true);
        AppUtils.printLog("AFTER POP");
        // Below method is popping data 2 times so need to handle this
        if (accessIdData == null) {
          accessIdData = data;
          await methodChannel
              .invokeMethod('getAccessRequestId', {"accessRequestId": data});
          accessIdData = null;
        }
      } else {
        widget.onCompletion(data);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          actions: [
            ElevatedButton(
              onPressed: () async {
                digiLockerURL = null;
                genDLUrl();
              },
              child: const Text('Refresh'),
            ),
          ],
          title: Text(widget.sdkAppBarTitle!),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: isUploading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : digiLockerURL != null
                  ? WebViewWidget(controller: _controller)
                  : Center(
                      child: GestureDetector(
                        onTap: genDLUrl,
                        child: Text(
                          errorMsg != null
                              ? '$errorMsg. Click to Retry'
                              : 'Loading...',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
        ),
      );

  void genDLUrl() async {
    if (digiLockerURL == null) {
      setState(() => isUploading = true);
      String redirectUrl = widget.redirectURL!;
      await digiLockerGenerateURL('1212121', redirectUrl);
    }
  }

  Future<void> digiLockerGenerateURL(String reqId, String redirectUrl) async {
    var headers = {
      'x-api-key': UrlConstants.X_API_KEY,
      'key': widget.secretKey!, // AppConstants.MOSFL_HEADER_KEY_VAL,
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse(UrlConstants.DIGI_LOCKER_GEN_URL));
    request.body = json.encode({
      "request_id": reqId,
      "ts": AppUtils.getCurrTimeStamp(),
      "redirect_url": redirectUrl,
      "flutter": true // Shared by Devashish on 20-07-23
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String res = await response.stream.bytesToString();
    final parsed = json.decode(res);

    AppUtils.printLog("SERVICE_TOKEN Url:$request");
    AppUtils.printLog("SERVICE_TOKEN Response:$parsed");

    genUrlResponseToken = GenUrlResponseToken.fromJson(parsed);

    setState(() {
      isUploading = false;
    });

    if (response.statusCode == 200) {
      if (genUrlResponseToken?.status == true) {
        AppUtils.printLog("DIGI LINK: ${genUrlResponseToken?.result?.link}");
        digiLockerURL = genUrlResponseToken?.result?.link;

        _controller.loadRequest(Uri.parse(digiLockerURL!));
      } else {
        errorMsg = genUrlResponseToken?.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${genUrlResponseToken?.message}'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                genDLUrl();
              },
            ),
          ),
        );
        AppUtils.printLog('Error Occurred');
      }
    } else {
      errorMsg = response.reasonPhrase;
      AppUtils.printLog(response.reasonPhrase);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.reasonPhrase}'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              genDLUrl();
            },
          ),
        ),
      );
    }
  }
}
