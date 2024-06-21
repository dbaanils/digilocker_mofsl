/*
import 'dart:convert';
import 'package:ainxt_digi_locker/constants/url_constants.dart';
import 'package:ainxt_digi_locker/models/gen_url_response_token.dart';
import 'package:ainxt_digi_locker/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIProvider extends ChangeNotifier{
  GenUrlResponseToken? genUrlResponseToken;

  Future<void> digiLockerGenerateURL(BuildContext context, String reqId, String redirectUrl) async {
    var headers = {
      'x-api-key': 'CAz0T7jv0g570ywQ38RE42G6XhbmLHOs2iOsUA9p',
      'key': '79993401FEAD58EE8B4965C62CCE60E4',
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

    print("SERVICE_TOKEN Url:$request");
    print("SERVICE_TOKEN Response:$parsed");

    genUrlResponseToken = GenUrlResponseToken.fromJson(parsed);

    if (response.statusCode == 200) {
      if(genUrlResponseToken?.status == true){
        print('LINK: ${genUrlResponseToken?.result?.link}');
        notifyListeners();
      }else{
        notifyListeners();
        print('Error Occurred');
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }
}*/
