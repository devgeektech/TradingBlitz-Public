import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../backend/model/get_stats.dart';
import '../../testing.dart';
import '../../utils/toast.dart';
import '../../widget/common_progress.dart';
import '../../widget/view_weekly_graph.dart';
import 'performance_state.dart';

class PerformanceLogic extends GetxController {
  final PerformanceState state;

  PerformanceLogic({required this.state});

  GetStatModel getStat = GetStatModel();

  WeeklyDataPoint weeklyDataPoint = WeeklyDataPoint();
  final List<WeeklyDataPoint> myApiData = [];
  List<DataPoint> data = [];


  RxBool statsLoader = true.obs;


  getStatsData(BuildContext context) async {
    if (context.mounted) statsLoader.value = true;
    var response = await state.getStats();
    if (context.mounted) statsLoader.value = false;
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      getStat = GetStatModel.fromJson(myMap);
      update();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }

  getStatsMapData(BuildContext context) async {
    // if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await state.getStatsGraphs();
    // if (context.mounted) LoadingDialog.dismissLoadingDialog(context);

    if (response != null && response.statusCode == 200) {
      List<dynamic> rawList = response.data;
      myApiData.clear();
      data.clear();

      myApiData.addAll(rawList.map((item) {
        final point = WeeklyDataPoint.fromJson(item);
          return WeeklyDataPoint(
            time: formatDateTimeToConstructor(point.time!),
            value: point.value,
          );
      }));
      debugPrint('RESPONSE ===  : $myApiData');

      for (int i = 0; i < myApiData.length; i++) {
        data.add(DataPoint(date: myApiData[i].time!, value: myApiData[i].value!));
      }

      update();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }


  resetApi(BuildContext context) async{
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await state.getResetApi({});
    if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint('RESPONSE-RESET-: $myMap');
      if(myMap['message'] != 'No game history found.'){
        getStatsData(context);
        getStatsMapData(context);
      }
      successToast(myMap['message']);
      update();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }



  DateTime formatDateTimeToConstructor(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }
}
