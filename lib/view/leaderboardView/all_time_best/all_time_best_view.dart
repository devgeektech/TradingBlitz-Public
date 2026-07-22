import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/utils.dart';
import 'package:trading/view/leaderboardView/all_time_best/all_time_best_logic.dart';
import 'package:trading/widget/common_leaderboard_widget.dart';
import 'package:trading/widget/commontext.dart';

import '../../../utils/connect_user.dart';
import '../../../widget/challenge_dialog.dart';

class AllTimeBestPage extends StatefulWidget {
  final String? search;
  final Function? callBack;

  const AllTimeBestPage({super.key, this.search, this.callBack});

  @override
  State<AllTimeBestPage> createState() => _AllTimeBestPageState();
}

class _AllTimeBestPageState extends State<AllTimeBestPage> {
  final _allTimeBestLogic = Get.put(AllTimeBestLogic(state: Get.find()));

  @override
  void initState() {
    super.initState();
    // Initialize search
    _allTimeBestLogic.search = widget.search ?? '';
    if (_allTimeBestLogic.search.isNotEmpty) {
      _allTimeBestLogic.searchLoader = true;
      _allTimeBestLogic.getTimeBest(context, 1, _allTimeBestLogic.search);
    }
  }

  @override
  void didUpdateWidget(covariant AllTimeBestPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only react if search actually changed
    print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  ${oldWidget.search},  ${widget.search}');

    if (oldWidget.search != widget.search) {
      _allTimeBestLogic.search = widget.search ?? '';
      if (_allTimeBestLogic.search.isNotEmpty) {
        _allTimeBestLogic.searchLoader = true;
        _allTimeBestLogic.getTimeBest(context, 1, _allTimeBestLogic.search);
      }
    }else if (widget.search.toString().isEmpty){
      _allTimeBestLogic.searchLoader = true;
      _allTimeBestLogic.getTimeBest(context, 1, '');
    }
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllTimeBestLogic>(
        init: AllTimeBestLogic(state: Get.find()),
        builder: (logic) {
          return NotificationListener<ScrollNotification>(
            onNotification: logic.onScrollNotification,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme
                  .of(context)
                  .brightness == Brightness.dark ? Colors.transparent : Color(0XFFF6F6F6),
              body: logic.mainLoader
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                onRefresh: () {
                  _allTimeBestLogic.currentPage = 1;
                  widget.callBack!();
                  return logic.getTimeBest(context, _allTimeBestLogic.currentPage, "");
                },
                child: Column(
                  spacing: 2.h,
                  children: [
                    //Heading Line
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        children: [
                          SizedBox(
                              width: Get.width / 12,
                              child: CommonTextWidget(
                                heading: "Rank".tr,
                                fontSize: Utils.responsiveFontSize(context, 14.sp),
                                color: Theme
                                    .of(context)
                                    .brightness == Brightness.dark
                                    ? ThemeProvider.whiteColor
                                    : ThemeProvider.blackColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Urbanist",
                              )),
                          buildTableCell(context, heading: 'Member'.tr),
                          SizedBox(
                            width: 2.w,
                          ),
                          buildTableCell(context, heading: 'Country'.tr),
                          buildTableCell(context, heading: 'Net Worth'.tr),
                          buildTableCell(context, heading: 'Challenge'.tr),
                        ],
                      ),
                    ),

                    //Data builder
                    logic.leaderTbList.isEmpty
                        ? Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(height: 60),
                        CommonTextWidget(
                          textAlign: TextAlign.center,
                          heading: "No Data Found!".tr,
                          fontSize: Utils.responsiveFontSize(context, 17.sp),
                          fontWeight: FontWeight.w800,
                          color: ThemeProvider.whiteColor,
                          fontFamily: "Urbanist",
                        )
                      ],
                    ) : _allTimeBestLogic.searchLoader ? CircularProgressIndicator() : Expanded(
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: logic.leaderTbList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 2.5.h),
                                decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .brightness == Brightness.dark
                                        ? ThemeProvider.buttonColor.withAlpha(35)
                                        : ThemeProvider.buttonColor.withAlpha(8),
                                    borderRadius: BorderRadius.circular(2.h)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: Get.width / 12,
                                          child: CommonTextWidget(
                                            heading: logic.leaderTbList[index].rank.toString(),
                                            fontSize: Utils.responsiveFontSize(context, 14.sp),
                                            color: ThemeProvider.whiteColor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Urbanist",
                                          )),


                                      buildTableCell(context,
                                          memberName: logic.leaderTbList[index].username,
                                          heading: "Member",
                                          isContent: true,
                                          memberImage: logic.leaderTbList[index].image),
                                      SizedBox(width: 2.w),
                                      buildTableCell(context,
                                          heading: "Country", isContent: true, flag: logic.leaderTbList[index].userFlag),
                                      buildTableCell(context,
                                          netWorth: '\$${logic.leaderTbList[index].accountBalance}',
                                          isContent: true,
                                          heading: "Net Worth"),
                                      buildTableCell(context, heading: "Challenge", isContent: true, isOnline: false,
                                          callBack: () async {
                                            challengeDialog(
                                              onConfirm: (value) {
                                                Get.back();
                                                challengeAcceptedDialog(
                                                  onConfirm: (value) {},
                                                  context: context,
                                                  dataList: logic.getWagerModel.options,
                                                  title: "You've Been Challenged".tr,
                                                  message: ''.tr,
                                                  confirmText: "Enter Challenge",
                                                );
                                              },
                                              context: context,
                                              dataList: logic.getWagerModel.options,
                                              title: "Add your Wager".tr,
                                              message: 'Clicking "Enter challenge" will exit all open solo position'.tr,
                                              confirmText: "Enter Challenge",
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              )
                            ],
                          );
                        },
                      )),


                    Obx(() {
                      return (_allTimeBestLogic.paginationLoader.value) ?  Container(
                          margin: EdgeInsets.all(1),
                          height: 20, width: 20,
                          child: CircularProgressIndicator()) : SizedBox();
                    }),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
