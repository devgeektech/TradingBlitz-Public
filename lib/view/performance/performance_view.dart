import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/widget/view_weekly_graph.dart';

import '../../testing.dart';
import '../../utils/app_assets.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../widget/alert_box.dart';
import '../../widget/button.dart';
import '../../widget/commontext.dart';
import 'performance_logic.dart';

class PerformancePage extends StatefulWidget {
  const PerformancePage({super.key});

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class ChartDataPoint {
  final DateTime date;
  final double? value;

  ChartDataPoint({required this.date, required this.value});
}

enum ChartRange { week, lastMonth, lastYear, }

class _PerformancePageState extends State<PerformancePage> {
  ChartRange selectedRange = ChartRange.week;
  final _performanceLogic = Get.put(PerformanceLogic(state: Get.find()));


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performanceLogic.getStatsData(context);
      _performanceLogic.getStatsMapData(context);
    });
  }

  Widget items({Color? color, required String itemName, required String price}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonTextWidget(
          textAlign: TextAlign.start,
          heading: "$itemName:",
          fontSize: Utils.responsiveFontSize(context, 15.sp),
          fontWeight: FontWeight.w600,
          color: color ?? ThemeProvider.whiteColor,
          fontFamily: "Urbanist",
          useThemeColors: color == null ? true : false,
        ),
        Flexible(
          child: CommonTextWidget(
            textAlign: TextAlign.start,
            heading: price,
            textOverflow: TextOverflow.ellipsis,
            fontSize: Utils.responsiveFontSize(context, 15.sp),
            fontWeight: FontWeight.w600,
            color: ThemeProvider.whiteColor,
            fontFamily: "Urbanist",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartWidth = MediaQuery.of(context).size.width * .57;
    final chartHeight =  MediaQuery.of(context).size.height * .68;
    return GetBuilder<PerformanceLogic>(
        init: PerformanceLogic(state: Get.find()),
        builder: (logic) {
          return SafeArea(
            right: true,left: true,top: false,bottom: true,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient:
                      Theme.of(context).brightness == Brightness.dark ? darkThemeBackgroundGradient : lightThemeBackgroundGradient,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 5.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Color(0XFFF6F6F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 2.w,
                              children: [
                                //heading

                                Expanded(
                                  flex: 3,
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 5.h),
                                        child:  Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          spacing: 5.h,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Container(
                                                  height: 40,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                  ),
                                                  child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    icon: Container(
                                                      padding: EdgeInsets.all(1.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(100),
                                                          color: ThemeProvider.whiteColor,
                                                          border: Border.all(
                                                              color: ThemeProvider.buttonColor.withValues(alpha: .6),
                                                              width: 2)),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        spacing: 1.w,
                                                        children: [
                                                          Transform(
                                                            transform: Matrix4.translationValues(0, 2, 0),
                                                            child: SvgPicture.asset(
                                                              AssetPath.arrowBack,
                                                            ),
                                                          ),

                                                          CommonTextWidget(
                                                            textAlign: TextAlign.center,
                                                            heading: "Stats".tr,
                                                            fontSize: Utils.responsiveFontSize(context, 18.sp),
                                                            fontWeight: FontWeight.w600,
                                                            color: ThemeProvider.buttonColor,
                                                            fontFamily: "Urbanist",
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  )),

                                            Obx(() => logic.statsLoader.value
                                                ? SizedBox(
                                              height: chartHeight-100,
                                                child: Center(child: CircularProgressIndicator()))
                                                : logic.getStat.data != null
                                                ? Column(
                                              spacing: 8.h,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 1.w,right: 1.w),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    spacing: 3.h,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      items(
                                                          itemName: "Rank".tr,
                                                          price: "${logic.getStat.data?.rank}"),
                                                      items(
                                                          itemName: "Account Balance".tr,
                                                          price: "\$ ${Utils.formatInternational(logic.getStat.data?.accountBalance.toString() ?? '0.00')}"),
                                                      items(
                                                          itemName: "Charts Played".tr,
                                                          price: "${logic.getStat.data?.chartsPlayed ?? '0.00'}"),
                                                      items(
                                                          itemName: "% Win Rate".tr,
                                                          price: "${logic.getStat.data?.winPercentage ?? ' 0'}%"),
                                                      items(itemName: "Profit / Loss Ratio".tr, price: "${logic.getStat.data?.totalProfitLoss ?? '0'}"),
                                                      items(
                                                          itemName: "Average Hold Period".tr,
                                                          price:
                                                          "${logic.getStat.data?.averageHoldTimeDays ?? ' 0'} ${logic.getStat.data!.averageHoldTimeDays <= 1 ? "Day" : "days"}"),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 7.w),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [

                                                      GestureDetector(
                                                        onTap:() {
                                                          showCommonDialog(
                                                            context: context,
                                                            message: "Are you sure you want to reset trade history?".tr,
                                                            title: "Reset Trade History".tr,
                                                            onConfirm: () {
                                                              logic.resetApi(context);
                                                            },
                                                          );
                                                        },
                                                        child: CommonTextWidget(
                                                          textAlign: TextAlign.start,
                                                          heading: "Reset Trade History".tr,
                                                          fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                          fontWeight: FontWeight.w500,
                                                          color: ThemeProvider.redColor2,
                                                          textDecoration: TextDecoration.none, // Remove actual underline
                                                          fontFamily: "Urbanist",
                                                        ),
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ) : SizedBox()),
                                            
                                            
                                            
                                            
                                             
                                          ],
                                        )
                                            ,
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 7,
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(vertical: 1.w),
                                    children: [
                                      Card(
                                        elevation: 10,
                                        color:
                                            Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Color(0XFFF6F6F6),
                                        child: Column(
                                          spacing: 2.h,
                                          children: [
                                            SizedBox(height: 1.h),
                                            /* Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                                              child: CommonTextWidget(
                                                textAlign: TextAlign.start,
                                                heading: "Overall Performance".tr,
                                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                fontWeight: FontWeight.w600,
                                                color: ThemeProvider.textColor,
                                                fontFamily: "Urbanist",
                                              ),


                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                spacing: 5.w,
                                                children: [
                                                  CommonTextWidget(
                                                    textAlign: TextAlign.start,
                                                    heading: "Overall Performance".tr,
                                                    fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                    fontWeight: FontWeight.w600,
                                                    color: ThemeProvider.textColor,
                                                    fontFamily: "Urbanist",
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ?Colors.white10
                                                            :Color(0XFFF6F6F6),
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withValues(alpha: 0.05),
                                                            blurRadius: 4,
                                                            offset: const Offset(0, 2), // drop shadow downward
                                                          ),
                                                        ],
                                                      ),
                                                      child: DropdownButtonHideUnderline(
                                                        child: DropdownButton<ChartRange>(
                                                          value: selectedRange,
                                                          isExpanded: true,
                                                          icon: const Icon(Icons.arrow_drop_down),
                                                          dropdownColor: Theme.of(context).brightness == Brightness.dark
                                                              ? Colors.grey[900]
                                                              : Colors.white,
                                                          borderRadius: BorderRadius.circular(10),
                                                          style: TextStyle(
                                                            color: Theme.of(context).brightness == Brightness.dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                          items: ChartRange.values.map((e) {
                                                            return DropdownMenuItem(
                                                              value: e,
                                                              child: Text(
                                                                e.toString().split('.').last.replaceAllMapped(
                                                                  RegExp(r'([A-Z])'),
                                                                      (m) => ' ${m[1]}',
                                                                ).trim(),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (val) {
                                                            if (val != null) {
                                                              setState(() => selectedRange = val);
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),*/
                                            SizedBox(
                                              width: chartWidth,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: SizedBox(
                                                  width: chartWidth,
                                                  height: chartHeight,
                                                  child: (selectedRange == ChartRange.week)
                                                      ? LineChartWidget(data: logic.data)
                                                      : (selectedRange == ChartRange.lastMonth)
                                                          ? MonthlyPerformanceChart()
                                                          : (selectedRange == ChartRange.lastYear)
                                                              ? YearlyPerformanceChart()
                                                              : WeeklyPerformanceChart(apiData: logic.myApiData),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 1.h),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
