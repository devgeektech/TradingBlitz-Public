import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading/main.dart';
import '../../../backend/model/get_leader_board.dart';
import '../../../backend/model/get_wager_model.dart';
import '../../../utils/open_web_view.dart';
import '../../../utils/string.dart';
import '../../../utils/toast.dart';
import '../../../widget/common_progress.dart';
import 'all_time_best_state.dart';

class AllTimeBestLogic extends GetxController {
  final AllTimeBestState state;
  AllTimeBestLogic({required this.state});

  GetLeaderBoardModel _getLeaderBoardModel = GetLeaderBoardModel();
  List<LeaderBody> leaderTbList = [];
  int currentPage = 1;
  bool mainLoader = true;
  bool searchLoader = false;
  RxBool paginationLoader = false.obs;
  String search = '';
  GetWagerModel getWagerModel = GetWagerModel();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentPage = 1;
      getTimeBest(getContext, currentPage, '');
      wagerGet(getContext);
      update();
    });
  }


  bool onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${_getLeaderBoardModel.next!}");
      if(_getLeaderBoardModel.next != null){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentPage++;
          paginationLoader.value = true;
          getTimeBest(getContext, currentPage,search);
        });
      }
    }
    return false;
  }

  getTimeBest(BuildContext context,int page, String search) async{
    var response = await state.getTb(page: page,search : search);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      _getLeaderBoardModel = GetLeaderBoardModel.fromJson(myMap);
      if(page == 1){ leaderTbList.clear(); }
      for(int i = 0; i< _getLeaderBoardModel.data!.length ;i++){
        leaderTbList.add(_getLeaderBoardModel.data![i]);
      }
      mainLoader = false;
      paginationLoader.value = false;
      searchLoader = false;
      update();
    } else {
      mainLoader = false;
      paginationLoader.value = false;
      searchLoader = false;
      update();
      debugPrint('RESPONSE : $response');
    }
  }

  wagerGet(BuildContext context) async{
    var response = await state.getWagerGet();
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      getWagerModel = GetWagerModel.fromJson(myMap);
      debugPrint('RESPONSE- WAGER: ${getWagerModel.options}');
      update();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }

  wagerApi(BuildContext context,String value) async{
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await state.getChallengeWager({'wager':value.toString()});
    if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint('RESPONSE-WAGER: $myMap');
      debugPrint('RESPONSE-WAGER: ${myMap['web_url']}');
      debugPrint('RESPONSE-WAGER: "${myMap['web_url']}/${state.sharedPreferencesManager.getString(AppString.authentication)}"');


      if(myMap['web_url'] != null){
        Get.to(() => WebViewOpen(
          webViewUrl: "${myMap['web_url']}?social_login=false&is_mobile=true&access_token=${state.sharedPreferencesManager.getString(AppString.authentication)}",
          titleName: "Challenges".tr,
        ), transition: Transition.downToUp);
      }else{
        errorToast(myMap['message']);
      }
      update();
    } else {
      debugPrint('RESPONSE : $response');
    }

  }

}
