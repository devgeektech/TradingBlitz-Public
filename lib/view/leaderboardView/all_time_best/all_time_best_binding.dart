import 'package:get/get.dart';
import 'package:trading/view/leaderboardView/all_time_best/all_time_best_logic.dart';

class AllTimeBestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllTimeBestLogic(state: Get.find()));
  }
}
