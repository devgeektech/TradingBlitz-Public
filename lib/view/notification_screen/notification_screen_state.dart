import 'package:trading/backend/api/api.dart';
import 'package:trading/backend/helper/shared_pref.dart';
import 'package:trading/utils/api_endpoint.dart';
import '../../utils/string.dart';

class NotificationScreenState {
final SharedPreferencesManager sharedPreferencesManager;
final ApiService apiService;

NotificationScreenState({required this.apiService, required this.sharedPreferencesManager});

  getNotify() async {
    return await ApiService.getApiWithHeader(notificationSettings, sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }

  setNotify(Map<String, Object> body) async{
    return await ApiService.postApiWithBody(
        'notification-settings/update/', sharedPreferencesManager.getString(AppString.authentication) ?? '',
        body: body);
  }
}
