import 'package:flutter/foundation.dart';

class AppUtils{
  static String getCurrTimeStamp(){
    String year = DateTime.now().year.toString();
    String month = DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month.toString();
    String day = DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day.toString();
    String hour = DateTime.now().hour < 10 ? '0${DateTime.now().hour}' : DateTime.now().hour.toString();
    String minute = DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : DateTime.now().minute.toString();
    String second = DateTime.now().second < 10 ? '0${DateTime.now().second}' : DateTime.now().second.toString();

    String timestamp = '$year$month$day$hour$minute$second';
    print('timestamp $timestamp');
    return timestamp;
  }

  static void printLog(String? msg){
    if (kDebugMode) {
      print(msg);
    }
  }

}