import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading/widget/common_progress.dart';

import 'notification_screen_state.dart';

class NotificationScreenLogic extends GetxController {
  final NotificationScreenState state;
  NotificationScreenLogic({required this.state});

  bool isChallengeNotificationEnabled = true;
  bool isForumNotificationEnabled = true;
  bool isWeeklyPostsNotificationEnabled = true;
  String selectedOption = 'Daily';

  getNotificationSetting(BuildContext context) async{
    LoadingDialog.showLoadingDialog(context);
    var response = await state.getNotify();
    LoadingDialog.dismissLoadingDialog(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint('myMap  ===== >>>  ${myMap['data']}');

      isChallengeNotificationEnabled = myMap['data']['challenge'];
      isForumNotificationEnabled = myMap['data']['forum_comment'];
      isWeeklyPostsNotificationEnabled = myMap['data']['weekly_trending_posts'];
      selectedOption = myMap['data']['top_traders_frequency'][0].toUpperCase() + myMap['data']['top_traders_frequency'].substring(1);
      update();
    } else {
      update();
      debugPrint('RESPONSE : $response');
    }
  }


  setNotificationSetting(BuildContext context) async{
    var body = {
      "challenge": isChallengeNotificationEnabled,
      "top_traders_frequency": selectedOption.toLowerCase(),
      "forum_comment": isForumNotificationEnabled,
      "weekly_trending_posts": isWeeklyPostsNotificationEnabled
    };

    var response = await state.setNotify(body);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint('myMap  ===== >>>  ${myMap['data']}');
      update();
    } else {
      update();
      debugPrint('RESPONSE : $response');
    }
  }



}
