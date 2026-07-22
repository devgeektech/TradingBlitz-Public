import '../../backend/api/api.dart';
import '../../backend/helper/shared_pref.dart';
import '../../utils/api_endpoint.dart';
import '../../utils/string.dart';

class PerformanceState {

  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PerformanceState({required this.sharedPreferencesManager, required this.apiService});


  getStats() async{
    return await ApiService.getApiWithHeader(statistics,sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }


  getStatsGraphs() async{
    return await ApiService.getApiWithHeader(graphPeriodWeekly,sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }



  getResetApi(Map<String, String> map) async{
    return await ApiService.postApiWithBody(gameHistoryReset,sharedPreferencesManager.getString(AppString.authentication) ?? '',body: map);
  }
}
