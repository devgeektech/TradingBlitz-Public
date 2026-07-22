import 'package:get/get.dart';

import 'leaderboard_logic.dart';


class LeaderboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaderboardLogic(state: Get.find()));
  }
}
