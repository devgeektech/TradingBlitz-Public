

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../helper/api_helper.dart';
import 'api.dart';

// GET METHOD
/*Note-- The return type depends on what response.data is expected to be.
 If it's complex, you might need to return dynamic.*/

Future<Response?> getData(String endpoint) async {


  debugPrint("END-POINT :: $endpoint");
  try {
    final response = await ApiService.dio.get(endpoint);
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}


Future<Response?> getDataWithHeader(String endpoint,{required String authToken}) async {

  Map<String, dynamic> header = {
    "Authorization": "Token $authToken",
    "Accept": "application/json",
  };

  debugPrint("END-POINT :: $endpoint");
  debugPrint("AUTHENTICATION :: $authToken");
  debugPrint("HEADER :: $header");


  try {
    final response = await ApiService.dio.get(endpoint,options: Options(headers: header,
      validateStatus: (status) => status != null && status < 500,));
    debugPrint("📦 Response: ${response.statusCode} — ${response.data}");
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}