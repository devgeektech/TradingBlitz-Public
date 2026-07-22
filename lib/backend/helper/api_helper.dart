

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as video;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trading/utils/toast.dart';
import '../../utils/video_controller.dart';
import 'app_router.dart';

final VideoController videoController = video.Get.put(VideoController());
class ApiHelper {

  static void handleStatusCode(Response response) {
    final int? statusCode = response.statusCode;
    final dynamic responseData = response.data;
    switch (statusCode) {
      case 200:
      case 201:
        break;

      case 400:
        debugPrint("Bad Request: $responseData");
        errorToast('Bad request. Please try again.');
        navigationPage();
        break;

      case 401:
        debugPrint("Unauthorized: $responseData");
        errorToast('Session expired. Please login again.');
        navigationPage();
        break;

      case 403:
        debugPrint("Forbidden: $responseData");
        errorToast('You don\'t have permission to access this resource.');
        navigationPage();
        break;

      case 404:
        debugPrint("Not Found: $responseData");
        errorToast('The requested resource was not found.');
        break;

      case 422:
        debugPrint("Unprocessable Entity: $responseData");
        errorToast('Invalid data provided.');
        break;

      case 500:
      case 502:
      case 503:
      case 504:
        debugPrint("Server Error ($statusCode): $responseData");
        errorToast('Oops! Something went wrong on our end.');
        break;

      default:
        debugPrint("Unhandled status: $statusCode - $responseData");
        errorToast('Unexpected error occurred.');
    }
  }


  static handleError(Object error) {
    String errorDescription = '';
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          errorDescription = 'Connection timeout with the server';
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = 'Send timeout in connection with the server';
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = 'Receive timeout in connection with the server';
          break;
        case DioExceptionType.badResponse:
          errorDescription = 'Received an invalid status code: ${error.response?.statusCode}';
          break;
        case DioExceptionType.cancel:
          errorDescription = 'Request to the server was cancelled';
          break;
        case DioExceptionType.unknown:
        default:
          errorDescription = 'Unexpected error occurred: ${error.message}';
          break;
      }
      debugPrint('Dio error: $errorDescription');
    } else {
      debugPrint('Unexpected error: $error');
    }
  }

  static navigationPage() async {
    try {
      SharedPreferences sharePref = await SharedPreferences.getInstance();
      sharePref.clear();
      await videoController.initializeVideo(isLocal: true).timeout(const Duration(seconds: 5));
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        video.Get.toNamed(AppRouter.getLoginRoute());
      });
    } catch (e) {
      debugPrint('❌ Video failed to load: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        video.Get.toNamed(AppRouter.getLoginRoute());
      });
    }
  }
}