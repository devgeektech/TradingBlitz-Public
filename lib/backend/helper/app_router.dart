import 'package:get/get.dart';
import 'package:trading/view/home/home_binding.dart';
import 'package:trading/view/home/home_screen.dart';
import 'package:trading/view/leaderboardView/all_time_best/all_time_best_binding.dart';
import 'package:trading/view/leaderboardView/all_time_best/all_time_best_view.dart';
import 'package:trading/view/leaderboardView/leaderboard/leaderboard_binding.dart';
import 'package:trading/view/leaderboardView/leaderboard/leaderboard_view.dart';
import 'package:trading/view/leaderboardView/online_leaderboard/online_leaderboard_binding.dart';
import 'package:trading/view/leaderboardView/online_leaderboard/online_leaderboard_view.dart';
import 'package:trading/view/login/login_binding.dart';
import 'package:trading/view/notification_screen/notification_screen_binding.dart';
import 'package:trading/view/notification_screen/notification_screen_view.dart';
import 'package:trading/view/settings_screen/settings_screen_binding.dart';
import 'package:trading/view/settings_screen/settings_screen_view.dart';
import 'package:trading/view/splash/splash_binding.dart';
import 'package:trading/view/splash/splash_screen.dart';
import 'package:trading/view/update_profile/update_profile_binding.dart';
import 'package:trading/view/update_profile/update_profile_view.dart';

import '../../view/login/login_screen.dart';
import '../../view/performance/performance_binding.dart';
import '../../view/performance/performance_view.dart';


class AppRouter {

  static const String splash = '/splash_screen';
  static const String login = '/login_screen';
  static const String home = '/home_screen';
  static const String leaderboard = '/leaderboard_view';
  static const String allTimeBest = '/all_time_best_view';
  static const String onlineLeaderboard = '/online_leaderboard_view';
  static const String settingScreen = '/settings_screen_view';
  static const String updateProfile = '/update_profile_view';
  static const String notificationScreen = '/notification_screen_view';
  static const String performance = '/performance';



  static String getSplashRoute() => splash;
  static String getLoginRoute() => login;
  static String getHomeRoute() => home;
  static String getLeaderboardRoute() => leaderboard;
  static String getAllTimeBestRoute() => allTimeBest;
  static String getOnlineLeaderboardRoute() => onlineLeaderboard;
  static String getSettingScreenRoute() => settingScreen;
  static String getUpdateProfileRoute() => updateProfile;
  static String getNotificationScreenRoute() => notificationScreen;
  static String getPerformance() => performance;


  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen(), binding: SplashBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: login, page: () => const LoginScreen(), binding: LoginBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: home, page: () => const HomeScreen(), binding: HomeScreenBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: leaderboard, page: () => const LeaderboardPage(), binding: LeaderboardBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: allTimeBest, page: () => AllTimeBestPage(), binding: AllTimeBestBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: onlineLeaderboard, page: () => const OnlineLeaderboardPage(), binding: OnlineLeaderboardBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: settingScreen, page: () => const SettingsScreenPage(), binding: SettingsScreenBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: updateProfile, page: () => const UpdateProfilePage(), binding: UpdateProfileBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: notificationScreen, page: () => const NotificationScreenPage(), binding: NotificationScreenBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
    GetPage(name: performance, page: () => const PerformancePage(), binding: PerformanceBinding(),transition: Transition.fadeIn,transitionDuration: const Duration(milliseconds: 300)),
  ];
}
