
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trading/utils/string.dart';
import '../../backend/helper/app_router.dart';
import '../../utils/video_controller.dart';
import 'splash_parser.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final SplashParser parser;
  SplashController({required this.parser});

  final VideoController videoController = Get.put(VideoController());

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    navigationPage();
    super.onInit();
  }

  navigationPage() async {
    String? authID = parser.sharedPreferencesManager.getString(AppString.authentication);
    debugPrint('AUTHENTICATION_TOKEN :: $authID');
    await Future.delayed(const Duration(seconds: 3));
    if (authID != null && authID.isNotEmpty) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      Get.offAllNamed(AppRouter.getHomeRoute());
    } else {
      try {
        // Set a timeout for video loading to avoid getting stuck
        await videoController
            .initializeVideo(isLocal: true)
            .timeout(const Duration(seconds: 5));
        Get.toNamed(AppRouter.getLoginRoute());
      } catch (e) {
        debugPrint('❌ Video failed to load: $e');
        Get.toNamed(AppRouter.getLoginRoute());
      }
    }
  }

}
