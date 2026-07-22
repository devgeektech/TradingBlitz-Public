import 'package:get/get.dart';
import 'package:trading/view/notification_screen/notification_screen_logic.dart';

class NotificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationScreenLogic(state: Get.find()));
  }
}
