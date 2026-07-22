
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trading/utils/string.dart';

import '../../../backend/helper/shared_pref.dart';
import '../../backend/api/api.dart';
import '../../backend/helper/app_router.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/toast.dart';
import '../../utils/video_controller.dart';

class HomeScreenParser {

  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  HomeScreenParser({required this.sharedPreferencesManager, required this.apiService});

  getDash() async {
    return await ApiService.getApiWithHeader(dashboardOverview,sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }
  getProfile() async {
    return await ApiService.getApiWithHeader(profile,sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }

  getWagerGet() async{
    return await ApiService.getApiWithHeader(wagerGet,sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }

  getChallengeWager(Map<String, String> map) async{
    return await ApiService.postApiWithBody(challengeEnter,sharedPreferencesManager.getString(AppString.authentication) ?? '',body: map);
  }


  final VideoController videoController = Get.put(VideoController());
   navigationPage() async {
    try {
      errorToast('Session expired. Please login again.');
      sharedPreferencesManager.clearAll();
      await videoController.initializeVideo(isLocal: true).timeout(const Duration(seconds: 5));
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        Get.toNamed(AppRouter.getLoginRoute());
      });
    } catch (e) {
      debugPrint('❌ Video failed to load: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        Get.toNamed(AppRouter.getLoginRoute());
      });
    }
  }

}
