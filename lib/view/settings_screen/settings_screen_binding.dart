import 'package:get/get.dart';
import 'package:trading/view/settings_screen/settings_screen_logic.dart';

class SettingsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsScreenLogic(state: Get.find()));
  }
}
