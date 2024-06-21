/*
import 'dart:convert';
import 'package:ainxt_digilocker_mod/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import '../constants/url_constants.dart';
import '../models/gen_url_response_token.dart';
import '../utils/app_utils.dart';
*/

/*
class AinxtDigiLockerSDKScreen extends StatefulWidget {
  String? redirectURL;
  String? redirectURLHost;
  String? sdkAppBarTitle;
  String? platform;
  String? secretKey;
  Function onCompletion;

  AinxtDigiLockerSDKScreen({Key? key, required this.platform, required this.sdkAppBarTitle, required this.redirectURL, required this.redirectURLHost, required this.secretKey, required this.onCompletion}) : super(key: key);

  @override
  State<AinxtDigiLockerSDKScreen> createState() => _AinxtDigiLockerSDKScreenState();
}

class _AinxtDigiLockerSDKScreenState extends State<AinxtDigiLockerSDKScreen> {

  final GlobalKey webViewKey = GlobalKey<RefreshIndicatorState>();
  InAppWebViewController? webViewController;

  GenUrlResponseToken? genUrlResponseToken;
  bool isUploading = false;
  String? digiLockerURL;
  String? errorMsg;
  final methodChannel = MethodChannel(AppConstants.FLUTTER_CHANNEL_ID);
  String? accessIdData;

  @override
  void initState() {
    super.initState();
    genDLUrl();
  }

  @override
  Widget build(BuildContext context) {
    String redirectURLHost = widget.redirectURLHost!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sdkAppBarTitle!),
        // TODO : added just to test pass data from flutter to Android and close flutter module
        actions:  [
          Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(20) ,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: (){
                      digiLockerURL = null;
                      genDLUrl();
                    },
                    child: const Text("Refresh"),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getUrl(),
          builder: (context, value){
            if(value.hasData){
              final data = value.data as String;
              return InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: Uri.parse(data)),
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  AppUtils.printLog("URL CHANGE: ${url.toString()}");
                  if (url!.host.contains(redirectURLHost) && url.toString().contains('accessRequestId')) {
                    var uri = Uri.dataFromString(url.toString()); //converts string to a uri
                    Map<String, String> params = uri.queryParameters; // query parameters automatically populated
                    var accessRequestId = params['accessRequestId']; // return value of parameter "param1" from uri
                    AppUtils.printLog("accessRequestId: $accessRequestId");
                    finishModuleWithData(accessRequestId);
                    return;
                  } else if (url.toString().contains("m")) {
                    var uri = Uri.dataFromString(url.toString()); //converts string to a uri
                    Map<String, String> params = uri.queryParameters; // query parameters automatically populated
                    var error = params['m']; // return value of parameter "param1" from uri
                    AppUtils.printLog("ERROR MESSAGE M: $error");
                    if(error != null){
                      finishModuleWithData(error);
                    }
                    return;
                  }
                },
              );
            }
            return Center(
              child: isUploading ? const CircularProgressIndicator() :
              GestureDetector(
                onTap: genDLUrl,
                child: Text(
                  errorMsg != null ? '$errorMsg. Click to Retry' : 'Loading...',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // This VIEW is called only For Android
  Future<void> finishModuleWithData(String? data) async{
    if(widget.platform == "ANDROID"){
      AppUtils.printLog("CAME INSIDE FINISH: ${widget.platform}");
      SystemNavigator.pop();
      // Below method is popping data 2 times so need to handle this
      if(accessIdData == null){
        accessIdData = data;
        await methodChannel.invokeMethod('getAccessRequestId', {"accessRequestId":accessIdData});
        accessIdData = null;
      }
    }else {
      widget.onCompletion(data);
    }
  }

  void genDLUrl() async{
    if(digiLockerURL == null){
      setState(() { isUploading = true; });
      String redirectUrl = widget.redirectURL!;
      accessIdData = null;
      await digiLockerGenerateURL('1212121', redirectUrl);
    }
  }

  Future<void> digiLockerGenerateURL(String reqId, String redirectUrl) async {
    var headers = {
      'x-api-key': UrlConstants.X_API_KEY,
      'key': widget.secretKey!, // AppConstants.MOSFL_HEADER_KEY_VAL,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(UrlConstants.DIGI_LOCKER_GEN_URL));
    request.body = json.encode({
      "request_id": reqId,
      "ts": AppUtils.getCurrTimeStamp(),
      "redirect_url": redirectUrl
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String res = await response.stream.bytesToString();
    final parsed = json.decode(res);

    AppUtils.printLog("REQUEST Url:$request");
    AppUtils.printLog("REQUEST Url header:${headers.toString()}"); // log
    AppUtils.printLog("REQUEST Url body:${request.body.toString()}");
    AppUtils.printLog("SERVICE_TOKEN Response:$parsed");

    genUrlResponseToken = GenUrlResponseToken.fromJson(parsed);

    setState(() {
      isUploading = false;
    });

    if (response.statusCode == 200) {
      if(genUrlResponseToken?.status == true){
        // AppUtils.printLog("DIGI LINK: ${genUrlResponseToken?.result?.link}");
        digiLockerURL = genUrlResponseToken?.result?.link;
      }else{
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
    }else {
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

  Future<String?> getUrl() async{
    return digiLockerURL;
  }

}
*/
