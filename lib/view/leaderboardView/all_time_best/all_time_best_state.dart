import 'package:trading/backend/api/api.dart';
import 'package:trading/backend/helper/shared_pref.dart';

import '../../../utils/api_endpoint.dart';
import '../../../utils/string.dart';

class AllTimeBestState {
final SharedPreferencesManager sharedPreferencesManager;
final ApiService apiService;

AllTimeBestState({required this.sharedPreferencesManager, required this.apiService});


getTb({required int page, required, required String search}) async {
    return await ApiService.getApiWithHeader("$leader?search=$search&page=${page.toString()}&limit=${search.isEmpty ? 10 : 100}",
        sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }

  getWagerGet() async {
  return await ApiService.getApiWithHeader(wagerGet,sharedPreferencesManager.getString(AppString.authentication) ?? '');
}

getChallengeWager(Map<String, String> map) async{
  return await ApiService.postApiWithBody(challengeEnter,sharedPreferencesManager.getString(AppString.authentication) ?? '',body: map);
}


}
