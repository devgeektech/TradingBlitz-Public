import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:trading/backend/helper/api_helper.dart';
import 'api.dart';

Future<Response?> putData(String endpoint, Map<String, dynamic> data) async {

  debugPrint("END-POINT :: $endpoint");
  debugPrint("BODY :: $data");

  try {
    final response = await ApiService.dio.put(endpoint, data: data);
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}

// PUT METHOD(Multipart)
Future<Response?> putDataWithImage(String endpoint, Map<String, dynamic> mapData, String? filePath, String authToken) async {
  Map<String, dynamic> header = {
    "Authorization": "Token $authToken",
    "Accept": "application/json",
  };

  debugPrint("END-POINT :: $endpoint");
  debugPrint("AUTHENTICATION :: $authToken");
  debugPrint("HEADER :: $header");
  debugPrint("BODY :: $mapData");

  try {
    FormData formData;
    if (filePath != null && filePath.isNotEmpty) {
      File file = File(filePath);
      String fileName = basename(file.path);
      formData = FormData.fromMap({
        ...mapData,
        'picture': await MultipartFile.fromFile(filePath, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        ...mapData,
      });
    }

    Response response = await ApiService.dio.put(
      endpoint, data: formData,
      options: Options(headers: header, validateStatus: (status) => status != null && status < 500),
    );
    debugPrint('Data: $response');
    ApiHelper.handleStatusCode(response);
    return response;
  } catch (e) {
    ApiHelper.handleError(e);
    return null;
  }
}
