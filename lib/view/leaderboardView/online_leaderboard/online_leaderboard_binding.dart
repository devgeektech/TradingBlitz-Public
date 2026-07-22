import 'package:get/get.dart';
import 'package:trading/view/leaderboardView/online_leaderboard/online_leaderboard_logic.dart';

class OnlineLeaderboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnlineLeaderboardLogic(state: Get.find()));
  }
}
