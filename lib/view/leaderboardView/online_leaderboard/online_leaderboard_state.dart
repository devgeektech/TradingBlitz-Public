import 'package:trading/backend/api/api.dart';
import 'package:trading/backend/helper/shared_pref.dart';

import '../../../utils/api_endpoint.dart';
import '../../../utils/string.dart';

class OnlineLeaderboardState {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  OnlineLeaderboardState({required this.sharedPreferencesManager, required this.apiService});

  getTb({required int page, required, String? search}) async {
return await ApiService.getApiWithHeader("$leaderOnline?search=$search&page=${page.toString()}&limit=${search.toString().isEmpty ? 10 : 100}",
        sharedPreferencesManager.getString(AppString.authentication) ?? '');
  }
}
