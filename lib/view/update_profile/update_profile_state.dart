import 'package:trading/backend/api/api.dart';
import 'package:trading/backend/helper/shared_pref.dart';

import '../../utils/api_endpoint.dart';
import '../../utils/string.dart';

class UpdateProfileState {
final SharedPreferencesManager sharedPreferencesManager;
final ApiService apiService;
UpdateProfileState({required this.apiService, required this.sharedPreferencesManager});

  updatedProfile(Map body, String? profileImage) async{
    return await ApiService.putApiWithImage(updateProfile,profileImage,sharedPreferencesManager.getString(AppString.authentication) ?? '', data: body);
  }

  deleteAccount() async{
    return await ApiService.deleteApiWithoutBody(deleteProfile,authToken: sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }

  getProfile() async {
    return await ApiService.getApiWithHeader(profile, sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }
}
