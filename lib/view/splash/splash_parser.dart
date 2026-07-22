import '../../backend/api/api.dart';
import '../../backend/helper/shared_pref.dart';

class SplashParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SplashParser({required this.sharedPreferencesManager, required this.apiService});



  bool haveLoggedIn() {
    return sharedPreferencesManager.getString('token') != '' &&
        sharedPreferencesManager.getString('token') != null
        ? true
        : false;
  }

  void savePhoneLange(String lang) {
     sharedPreferencesManager.putString('lang', lang);
  }
}
