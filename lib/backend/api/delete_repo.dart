
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trading/backend/helper/api_helper.dart';
import 'api.dart';



Future<Response?> deleteData(String endpoint,Map<String, dynamic> data) async {
  debugPrint("END-POINT :: $endpoint");
  debugPrint("BODY :: $data");
  try {
    final response = await ApiService.dio.delete(endpoint, data: data);
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}
Future<Response?> deleteDataWithoutBody(String endpoint,String authToken) async {
  Map<String, dynamic> header = {
    "Authorization": "Token $authToken",
    "Accept": "application/json",
  };

  debugPrint("END-POINT :: $endpoint");
  debugPrint("HEADER :: $header");
  debugPrint("AUTHENTICATION :: $authToken");
  try {
    final response = await ApiService.dio.delete(endpoint,options: Options(headers: header));
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}
