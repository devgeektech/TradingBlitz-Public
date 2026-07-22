import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInternetConnection();
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Check the internet connection initially
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  // Update the connection status
  void _updateConnectionStatus(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
  }
}
