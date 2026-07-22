import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../backend/model/get_leader_board_online.dart';
import '../../../main.dart';
import 'online_leaderboard_state.dart';

class OnlineLeaderboardLogic extends GetxController {
  final OnlineLeaderboardState state;
  OnlineLeaderboardLogic({required this.state});

  GetLeaderBoardOnlineModel _getLeaderBoardOnlineModel = GetLeaderBoardOnlineModel();
  List<LeaderOnlineBody> leaderTbList = [];
  int currentPage = 1;
  RxBool paginationLoader = false.obs;
  bool mainLoader = true;
  String search = '';


  bool onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      debugPrint("total pages :: ${_getLeaderBoardOnlineModel.next!}");
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

  getTimeBest(BuildContext context,int page, String? search) async{
    var response = await state.getTb(page: page,search: search);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      _getLeaderBoardOnlineModel = GetLeaderBoardOnlineModel.fromJson(myMap);
      if(page == 1){ leaderTbList.clear(); }
      for(int i = 0; i< _getLeaderBoardOnlineModel.data!.length ;i++){
        leaderTbList.add(_getLeaderBoardOnlineModel.data![i]);
      }
      mainLoader = false;
      paginationLoader.value = false;
      update();
    } else {
      mainLoader = false;
      update();
      debugPrint('RESPONSE : $response');
    }
  }



}