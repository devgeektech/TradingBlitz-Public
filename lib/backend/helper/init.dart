import 'package:get/get.dart';
import 'package:trading/view/leaderboardView/all_time_best/all_time_best_state.dart';
import 'package:trading/view/leaderboardView/leaderboard/leaderboard_state.dart';
import 'package:trading/view/leaderboardView/online_leaderboard/online_leaderboard_state.dart';
import 'package:trading/view/notification_screen/notification_screen_state.dart';
import 'package:trading/view/performance/performance_state.dart';
import 'package:trading/view/settings_screen/settings_screen_state.dart';
import 'package:trading/view/update_profile/update_profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/utils.dart';
import '../../view/home/home_parser.dart';
import '../../view/login/login_parser.dart';
import '../../view/splash/splash_parser.dart';
import '../api/api.dart';
import '../api/socket_service.dart';
import 'shared_pref.dart';


class MainBinding extends Bindings {

  @override
  Future<void> dependencies() async {

    final sharedPref = await SharedPreferences.getInstance();
    Get.put(SharedPreferencesManager(sharedPreferences: sharedPref), permanent: true);

    Get.lazyPut(() => ApiService(appBaseUrl: Utils.baseUrl));
    Get.lazyPut(() => SocketService(socketUrl : Utils.socketUrl));

    Get.lazyPut(() => SplashParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => LoginParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => HomeScreenParser(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => LeaderboardState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => AllTimeBestState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => OnlineLeaderboardState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => SettingsScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => UpdateProfileState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => NotificationScreenState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => PerformanceState(apiService: Get.find(),sharedPreferencesManager: Get.find()), fenix: true);


  }
}
