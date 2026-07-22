
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../helper/api_helper.dart';
import 'api.dart';




Future<Response?> postData(String endpoint,Map<String, dynamic> data) async {
    try {
      final response = await ApiService.dio.post(endpoint, data: data);
      ApiHelper.handleStatusCode(response);
      return response;
    } catch (e) {
      ApiHelper.handleError(e);
      return null;
    }
}


Future<Response?> postDataWithBody(String endpoint,String authToken, {required Map<String, dynamic>? body}) async {

  Map<String, dynamic> header = {
    "Authorization": "Token $authToken",
    "Accept": "application/json",
  };

  debugPrint("END-POINT :: $endpoint");
  debugPrint("HEADER :: $header");
  debugPrint("AUTHENTICATION :: $authToken");

  try {
    final response = await ApiService.dio.post(endpoint,data: body,options: Options(headers: header));
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}



Future<Response?> postDataWithoutBody(String endpoint,String authToken) async {

  Map<String, dynamic> header = {
    "Authorization": "Token $authToken",
    "Accept": "application/json",
  };

  debugPrint("END-POINT :: $endpoint");
  debugPrint("HEADER :: $header");
  debugPrint("AUTHENTICATION :: $authToken");

  try {
    final response = await ApiService.dio.post(endpoint,options: Options(headers: header));
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}


Future<Response?> postUploadImage(String endpoint, File imageFile, {Map<String, dynamic>? extraData}) async {
  try {
    // Prepare FormData
    String fileName = basename(imageFile.path); // Extracts the filename
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile.path, filename: fileName),
      if (extraData != null) ...extraData, // Include any additional data in the form
    });

    // Send POST request
    final response = await ApiService.dio.post(endpoint, data: formData);
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}

