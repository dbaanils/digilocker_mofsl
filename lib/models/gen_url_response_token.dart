

import 'gen_res_result_link.dart';

class GenUrlResponseToken{
  bool? status;
  String? message;
  String? resultId;
  GenResResultLink? result;

  GenUrlResponseToken({this.status, this.message, this.resultId, this.result});

  GenUrlResponseToken.fromJson(dynamic json):
        status = json['status'],
        message =  json['message'],
        resultId =  json['resultId'],
        result = json['result'] != null ? GenResResultLink.fromJson(json['result']) : null;

  Map<String, dynamic>  toJson() => {
    'status'  : status,
    'message' : message,
    'resultId': resultId,
    'result'  : result?.toJson() ,
  };

}