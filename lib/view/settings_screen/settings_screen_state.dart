import 'package:trading/backend/api/api.dart';
import 'package:trading/backend/helper/shared_pref.dart';

import '../../utils/api_endpoint.dart';
import '../../utils/string.dart';

class SettingsScreenState {
final SharedPreferencesManager sharedPreferencesManager;
final ApiService apiService;
SettingsScreenState({required this.sharedPreferencesManager,required this.apiService});


updatedProfile(Map body, String? profileImage) async{
  return await ApiService.putApiWithImage(updateProfile,profileImage,sharedPreferencesManager.getString(AppString.authentication) ?? '', data: body);
}

  logoutAccount() async{
    return await ApiService.postApiWithoutBody(logout,sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }

  getProfile() async {
    return await ApiService.getApiWithHeader(profile, sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }
}
