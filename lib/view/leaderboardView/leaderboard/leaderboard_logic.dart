import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../backend/model/get_leader_board.dart';
import '../../../backend/model/get_leader_board_online.dart';
import '../../../backend/model/get_wager_model.dart';
import '../../../main.dart';
import '../../../utils/open_web_view.dart';
import '../../../utils/string.dart';
import '../../../utils/toast.dart';
import '../../../widget/common_progress.dart';
import 'leaderboard_state.dart';

class LeaderboardLogic extends GetxController with GetSingleTickerProviderStateMixin{
  final LeaderboardState state;
  LeaderboardLogic({required this.state});

  ScrollController scrollController = ScrollController();
  final searchText = TextEditingController();
  var currentTabIndex = 0;
  Timer? debounce;

  bool isLoadingOne = true;
  bool isLoadingSecond = true;

  // 1
  bool mainLoader = true;
  int currentPage = 1;
  GetLeaderBoardModel _getLeaderBoardModel = GetLeaderBoardModel();
  List<LeaderBody> leaderTbList = [];
  bool searchLoader = false;
  RxBool paginationLoader = false.obs;
  String search = '';
  GetWagerModel getWagerModel = GetWagerModel();

  //2
  GetLeaderBoardOnlineModel _getLeaderBoardOnlineModel = GetLeaderBoardOnlineModel();
  List<LeaderOnlineBody> leaderTbListOnline = [];

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentTabIndex = Get.arguments ?? 0;
      currentPage = 1;
      if (currentTabIndex == 1) {
        getTimeBestOnline(getContext, currentPage, '');
      } else {
        getTimeBest(getContext, currentPage, '');
      }
      // wagerGet(getContext);
      update();
    });
    super.onInit();
  }


  bool onScrollNotification1(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${_getLeaderBoardModel.next ?? 0}");
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

  bool onScrollNotification2(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${_getLeaderBoardOnlineModel.next?? ""}");
      if(_getLeaderBoardOnlineModel.next != null){
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
      isLoadingOne = false;
      update();
    } else {
      mainLoader = false;
      paginationLoader.value = false;
      searchLoader = false;
      isLoadingOne = false;
      update();
      debugPrint('RESPONSE : $response');
    }
  }

  getTimeBestOnline(BuildContext context,int page, String? search) async{
    var response = await state.getTbOnline(page: page,search: search);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      _getLeaderBoardOnlineModel = GetLeaderBoardOnlineModel.fromJson(myMap);
      if(page == 1){ leaderTbListOnline.clear(); }
      for(int i = 0; i< _getLeaderBoardOnlineModel.data!.length ;i++){
        leaderTbListOnline.add(_getLeaderBoardOnlineModel.data![i]);
      }
      mainLoader = false;
      paginationLoader.value = false;
      isLoadingSecond = false;
      searchLoader = false;
      update();
    } else {
      mainLoader = false;
      searchLoader = false;
      paginationLoader.value = false;
      isLoadingSecond = false;
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

  void challengeRequestSend(BuildContext context,String value, String uuid) async{
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await state.getChallengeRequest({'wager':value.toString(), "user_id" : uuid.toString()});
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
