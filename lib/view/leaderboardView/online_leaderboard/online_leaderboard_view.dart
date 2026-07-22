import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/utils.dart';
import 'package:trading/view/leaderboardView/online_leaderboard/online_leaderboard_logic.dart';
import 'package:trading/widget/common_leaderboard_widget.dart';
import 'package:trading/widget/commontext.dart';

class OnlineLeaderboardPage extends StatefulWidget {
  final String? search;
  final Function? callBack;

  const OnlineLeaderboardPage({super.key, this.search, this.callBack});

  @override
  State<OnlineLeaderboardPage> createState() => _OnlineLeaderboardPageState();
}

class _OnlineLeaderboardPageState extends State<OnlineLeaderboardPage> {
  final _onlineLeaderLogic = Get.put(OnlineLeaderboardLogic(state: Get.find()));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onlineLeaderLogic.search = widget.search ?? '';
      _onlineLeaderLogic.getTimeBest(context, _onlineLeaderLogic.currentPage, "");
    });
  }

  @override
  void didUpdateWidget(covariant OnlineLeaderboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onlineLeaderLogic.search = widget.search ?? '';
    _onlineLeaderLogic.getTimeBest(context, 1, _onlineLeaderLogic.search);
    _onlineLeaderLogic.update();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnlineLeaderboardLogic>(
      init: OnlineLeaderboardLogic(state: Get.find()),
        builder: (logic) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:Theme.of(context).brightness == Brightness.dark
            ?Colors.transparent
            :Color(0XFFF6F6F6),
        body: logic.mainLoader
            ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () {
                      _onlineLeaderLogic.currentPage = 1;
                      widget.callBack!();
                      return _onlineLeaderLogic.getTimeBest(context, _onlineLeaderLogic.currentPage, "");
                    },
                    child: Column(
                      spacing: 1.h,
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
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? ThemeProvider.whiteColor
                                        : ThemeProvider.blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Urbanist",
                                  )),
                              buildTableCell(context, heading: 'Member'.tr),
                              SizedBox(width: 2.w),
                              buildTableCell(context, heading: 'Country'.tr),
                              buildTableCell(context, heading: 'Net Worth'.tr),
                              buildTableCell(context, heading: 'Challenge'.tr),
                              buildTableCell(context, heading: 'Won %'.tr),
                              // buildTableCell(context,heading: 'Trainer'.tr),
                            ],
                          ),
                        ),


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
                        ) : Expanded(
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: logic.leaderTbList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.5.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? ThemeProvider.buttonColor.withAlpha(35)
                                        : ThemeProvider.buttonColor.withAlpha(8),
                                    borderRadius: BorderRadius.circular(2.h),
                                  ),
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
                                            )
                                        ),
                                        buildTableCell(context,
                                            memberName: logic.leaderTbList[index].username,
                                            heading: "Member",
                                            isContent: true,
                                            memberImage: "assets/images/dummyImg.jpg"),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        buildTableCell(context,
                                            heading: "Country", isContent: true, flag: logic.leaderTbList[index].userFlag),
                                        buildTableCell(context,
                                            netWorth: '\$${logic.leaderTbList[index].accountBalance}', isContent: true, heading: "Net Worth"),
                                        buildTableCell(
                                          context,
                                          heading: logic.leaderTbList[index].challengesWon.toString(),
                                          isContent: true,
                                        ),
                                        buildTableCell(
                                          context,
                                          heading: logic.leaderTbList[index].winPercentage.toString(),
                                          isContent: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),

                        Obx(() {
                          return (_onlineLeaderLogic.paginationLoader.value)
                              ? Container(margin: EdgeInsets.all(1), height: 20, width: 20, child: CircularProgressIndicator())
                              : SizedBox();
                        }),
                      ],
                    ),
                  ),
      );
    });
  }
}
