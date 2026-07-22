import 'package:get/get.dart';
import 'package:trading/view/update_profile/update_profile_logic.dart';

class UpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateProfileLogic(state: Get.find()));
  }
}
