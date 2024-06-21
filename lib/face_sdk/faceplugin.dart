
import 'package:ainxt_digilocker_mod/face_sdk/preview2.dart';
import 'package:flutter/material.dart';

class Faceplugin {
  Faceplugin() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<dynamic> init(BuildContext context,
      {required String baseUrl,
      required String key,
      required String authToken}) async {
    //Open a modal dialog from bottom of the screen
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FaceSdkScreen(
          baseUrl: baseUrl,
          keyString: key,
          authToken: authToken,
        ),
      ),
    );
  }
}
