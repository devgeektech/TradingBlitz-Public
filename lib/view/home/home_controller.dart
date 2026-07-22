import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading/utils/toast.dart';
import '../../backend/model/get_profile.dart';
import '../../utils/open_web_view.dart';
import '../../utils/string.dart';
import '../../widget/common_progress.dart';
import 'home_parser.dart';

int addDelay = 0;
bool disableChallenge = false;
class HomeScreenController extends GetxController {
  final HomeScreenParser parser;
  HomeScreenController({required this.parser});

  final profile = GetProfileModel();
  String challengeText = '';
  String onlineUsers = '0';
  String accountBalance = '0';
  int totalGamePlayed = 0;
  bool isRefresh = false;
  RxBool dashboardLoader = true.obs;

  getDashboardApi(BuildContext context) async{
    if(context.mounted) dashboardLoader = true.obs;
     var response = await parser.getDash();
    if (context.mounted) dashboardLoader = false.obs;
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint('======> DASHBOARD   $myMap');
      disableChallenge = myMap['disable_challenge'];
      challengeText = myMap['disable_challenge_reason'];
      onlineUsers = myMap['online_users_count'].toString();
      accountBalance = myMap['account_value'].toString();
      totalGamePlayed = myMap['user_total_games'];
      addDelay = myMap['app_redirection_timeout'];
      update();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }

  getProfileApi(BuildContext context) async{
    var response = await parser.getProfile();
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      profile.fromJson(myMap);
      update();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }

  checkAuth(BuildContext context) async{
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await parser.getProfile();
    if (response != null && response.statusCode == 200) {
      wagerApi(context, "1000");
    } else {
      if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
      debugPrint('RESPONSE : $response');
    }
  }

  wagerApi(BuildContext context,String value) async{
    var response = await parser.getChallengeWager({'wager':value.toString()});
    if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint('RESPONSE-WAGER: $myMap');
      debugPrint('RESPONSE-WAGER: ${myMap['web_url']}');
      debugPrint('RESPONSE-WAGER: "${myMap['web_url']}/${parser.sharedPreferencesManager.getString(AppString.authentication)}"');

      if(myMap['web_url'] != null){
        Get.to(() => WebViewOpen(
          webViewUrl: "${myMap['web_url']}?social_login=false&is_mobile=true&access_token=${parser.sharedPreferencesManager.getString(AppString.authentication)}",
          titleName: "Challenges".tr,
        ), transition: Transition.downToUp);
      }else{
        errorToast(myMap['message']);
      }
      update();
    } else {
      parser.navigationPage();
      debugPrint('RESPONSE : $response');
    }
  }
}
