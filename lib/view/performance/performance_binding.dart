import 'package:get/get.dart';

import 'performance_logic.dart';

class PerformanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PerformanceLogic(state: Get.find()));
  }
}
