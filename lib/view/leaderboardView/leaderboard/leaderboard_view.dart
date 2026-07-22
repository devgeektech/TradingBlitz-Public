import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/utils/string.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/utils.dart';
import 'package:trading/view/leaderboardView/leaderboard/leaderboard_logic.dart';
import 'package:trading/widget/button.dart';
import 'package:trading/widget/commontext.dart';
import '../../../widget/back_button.dart';
import '../../../widget/challenge_dialog.dart';
import '../../../widget/common_leaderboard_widget.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {

  final logic = Get.put(LeaderboardLogic(state: Get.find()));
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeaderboardLogic>(builder: (logic) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: SafeArea(
          right: true,
          left: true,
          top: false,
          bottom: true,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient:
                    Theme.of(context).brightness == Brightness.dark ? darkThemeBackgroundGradient : lightThemeBackgroundGradient,
              ),
              child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      pinned: false,
                      floating: true,
                      snap: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      title: Row(
                        spacing: 2.w,
                        children: [
                          PopButton(onPressed: () {
                            Get.back();
                          }),
                          CommonTextWidget(
                            textAlign: TextAlign.center,
                            heading: "Leaderboard".tr,
                            fontSize: Utils.responsiveFontSize(context, 17.sp),
                            fontWeight: FontWeight.w800,
                            color: ThemeProvider.textColor,
                            fontFamily: "Urbanist",
                          ),
                        ],
                      ),
                    ),
                  ],
                  body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : const Color(0XFFF6F6F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // TAB BAR
                                    Flexible(
                                      flex: 6,
                                      child: Container(
                                        height: 8.h,
                                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.whiteColor,
                                          borderRadius: BorderRadius.circular(10.w),
                                        ),
                                        child: Row(
                                          children: [
                                            // Tab 1 : All Time Best
                                            Expanded(
                                              flex: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  logic.paginationLoader.value = false;
                                                  logic.searchText.text = '';
                                                  logic.currentPage = 1;
                                                  logic.isLoadingOne = true;
                                                  logic.getTimeBest(context, logic.currentPage, logic.searchText.text);
                                                  logic.currentTabIndex = 0;
                                                  logic.update();
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        logic.currentTabIndex == 0 ? ThemeProvider.primary : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(10.w),
                                                  ),
                                                  child: CommonTextWidget(
                                                    textAlign: TextAlign.center,
                                                    heading: "All Time Best".tr,
                                                    fontSize: Utils.responsiveFontSize(context, 18.sp),
                                                    fontWeight: FontWeight.w800,
                                                    color: logic.currentTabIndex == 0
                                                        ? ThemeProvider.whiteColor
                                                        : ThemeProvider.blackColor,
                                                    fontFamily: "Urbanist",
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Tab 2 : Online
                                            Expanded(
                                              flex: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  logic.searchText.text = '';
                                                  logic.currentPage = 1;
                                                  logic.searchLoader = false;
                                                  logic.leaderTbListOnline.clear();
                                                  logic.paginationLoader.value = false;
                                                  logic.isLoadingSecond = true;
                                                  logic.getTimeBestOnline(context, logic.currentPage, logic.searchText.text);
                                                  logic.currentTabIndex = 1;
                                                  logic.update();
                                                },
                                                child: AnimatedContainer(
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        logic.currentTabIndex == 1 ? ThemeProvider.primary : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(10.w),
                                                  ),
                                                  child: CommonTextWidget(
                                                    textAlign: TextAlign.center,
                                                    heading: "Online".tr,
                                                    fontSize: Utils.responsiveFontSize(context, 18.sp),
                                                    fontWeight: FontWeight.w800,
                                                    color: logic.currentTabIndex == 1
                                                        ? ThemeProvider.whiteColor
                                                        : ThemeProvider.blackColor,
                                                    fontFamily: "Urbanist",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // SEARCH FIELD
                                    Flexible(
                                      flex: 5,
                                      child: Container(
                                        height: 8.h,
                                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.whiteColor,
                                          borderRadius: BorderRadius.circular(10.w),
                                        ),
                                        child: TextField(
                                          controller: logic.searchText,
                                          textInputAction: TextInputAction.search,
                                          scrollPadding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom + Get.height * .1,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Search',
                                            hintStyle: TextStyle(
                                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'regular',
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                if (logic.currentTabIndex == 0) {
                                                  logic.currentPage = 1;
                                                  logic.searchLoader = true;
                                                  logic.getTimeBest(context, logic.currentPage, logic.searchText.text);
                                                  logic.update();
                                                } else {
                                                  logic.currentPage = 1;
                                                  logic.searchLoader = true;
                                                  logic.getTimeBestOnline(context, logic.currentPage, logic.searchText.text);
                                                  logic.update();
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(left: 12, right: 1),
                                                decoration: BoxDecoration(
                                                  color: ThemeProvider.primary,
                                                  borderRadius: BorderRadius.circular(10.w),
                                                  border: Border.all(color: Colors.grey.shade300),
                                                ),
                                                child: Icon(Icons.search),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                                            fontWeight: FontWeight.w800,
                                            color: ThemeProvider.blackColor,
                                            fontFamily: 'regular',
                                          ),

                                          // WHEN USER PRESSES ENTER
                                          onSubmitted: (value) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            if (logic.currentTabIndex == 0) {
                                              logic.currentPage = 1;
                                              logic.searchLoader = true;
                                              logic.getTimeBest(context, logic.currentPage, logic.searchText.text);
                                              logic.update();
                                            } else {
                                              logic.currentPage = 1;
                                              logic.searchLoader = true;
                                              logic.getTimeBestOnline(context, logic.currentPage, logic.searchText.text);
                                              logic.update();
                                            }
                                          },

                                          // CLEAR SEARCH WHEN EMPTY
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              if (logic.currentTabIndex == 0) {
                                                logic.currentPage = 1;
                                                logic.searchLoader = true;
                                                logic.getTimeBest(context, logic.currentPage, logic.searchText.text);
                                                logic.update();
                                              } else {
                                                logic.currentPage = 1;
                                                logic.searchLoader = true;
                                                logic.getTimeBestOnline(context, logic.currentPage, logic.searchText.text);
                                                logic.update();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                (logic.currentTabIndex == 0)
                                    ? Expanded(child: firstContainer(logic))
                                    : Expanded(child: secondContainer(logic)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }


  firstContainer(LeaderboardLogic logic) {
    return logic.mainLoader
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              logic.currentPage = 1;
              logic.searchText.text = '';
              return logic.getTimeBest(context, logic.currentPage, "");
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: logic.onScrollNotification1,
              child: Column(
                spacing: 2.h,
                children: [

                  //Heading Line
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(
                      children: [
                        buildTableCell(context, flexValue: 1,heading: 'Rank'.tr),
                        buildTableCell(context, flexValue: 4,heading: 'Member'.tr),
                        buildTableCell(context, flexValue: 3,heading: 'Country'.tr),
                        buildTableCell(context, flexValue: 3,heading: 'Net Worth'.tr),
                        buildTableCell(context, flexValue: 3,heading: 'Challenge'.tr),
                      ],
                    ),
                  ),

                  //Data builder
                  logic.isLoadingOne || logic.searchLoader
                      ? CircularProgressIndicator()
                      : logic.leaderTbList.isNotEmpty
                          ? Expanded(
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
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? ThemeProvider.buttonColor.withAlpha(35)
                                              : ThemeProvider.buttonColor.withAlpha(8),
                                          borderRadius: BorderRadius.circular(2.h)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                                        child: Row(
                                          children: [

                                            buildTableCell(context,
                                                flexValue: 1,
                                                trainer: logic.leaderTbList[index].rank.toString(),
                                                heading: "Rank",
                                                isContent: true),


                                            buildTableCell(context,
                                                flexValue: 3,
                                                memberName: logic.leaderTbList[index].username,
                                                heading: "Member",
                                                isContent: true,
                                                memberImage: logic.leaderTbList[index].image),

                                            buildTableCell(context,
                                                flexValue: 1,
                                                netWorth: "",
                                                isContent: true,
                                                heading: "Net Worth"),

                                            buildTableCell(context,
                                                flexValue: 1,
                                                heading: "Country", isContent: true, flag: logic.leaderTbList[index].userFlag),


                                            buildTableCell(context,
                                                flexValue: 3,
                                                textAlign: Alignment.centerRight,
                                                netWorth: "\$ ${Utils.formatInternational(logic.leaderTbList[index].accountBalance.toString())}",
                                                isContent: true,
                                                heading: "Net Worth"),

                                            buildTableCell(context,
                                                flexValue: 2,
                                                netWorth: "",
                                                isContent: true,
                                                heading: "Net Worth"),


                                            buildTableCell(context,
                                                flexValue: 3,
                                                heading: (logic.state.sharedPreferencesManager.getString(AppString.userId) !=
                                                        logic.leaderTbList[index].uuid) ? "Challenge" : '',
                                                challengeEnable: logic.leaderTbList[index].disableButtonConditionally,
                                                isContent: true,
                                                isOnline: false,
                                                callBack: () async {
                                                  challengeDialog(
                                                      onConfirm: (value) {
                                                        Get.back();
                                                        logic.challengeRequestSend(context, value, logic.leaderTbList[index].uuid);
                                                      },
                                                      context: context,
                                                      // dataList: getWagerModel.options,
                                                      title: "Send a Challenge".tr,
                                                      message: 'Click "Send Challenge" below'.tr,
                                                      confirmText: "Send Challenge");
                                            }),

                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2.h)
                                  ],
                                );
                              },
                            ))
                          : Wrap(
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
                            ),

                  Obx(() {
                    return (logic.paginationLoader.value)
                        ? Container(margin: EdgeInsets.all(1), height: 20, width: 20, child: CircularProgressIndicator())
                        : SizedBox();
                  }),
                ],
              ),
            ),
          );
  }


  secondContainer(LeaderboardLogic logic) {
    return logic.mainLoader
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {},
            child: NotificationListener<ScrollNotification>(
              onNotification: logic.onScrollNotification2,
              child: Column(
                spacing: 1.h,
                children: [
                  //Heading Line
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(
                      children: [
                        buildTableCell(context, flexValue: 1,heading: 'Rank'.tr),
                        buildTableCell(context, flexValue: 3,heading: 'Member'.tr),
                        buildTableCell(context, flexValue: 2,heading: 'Country'.tr),
                        buildTableCell(context, flexValue: 3,heading: 'Net Worth'.tr),
                        buildTableCell(context, flexValue: 3,heading: 'Challenge'.tr),
                        buildTableCell(context, flexValue: 1,heading: 'Won %'.tr),
                      ],
                    ),
                  ),

                logic.isLoadingSecond || logic.searchLoader
                      ? CircularProgressIndicator()
                      : logic.leaderTbListOnline.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: logic.leaderTbListOnline.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 2.5.h),
                                      margin: EdgeInsets.symmetric(vertical: 1.h),
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

                                            buildTableCell(context,
                                                flexValue: 1,
                                                trainer: logic.leaderTbListOnline[index].rank.toString(),
                                                heading: "Rank",
                                                isContent: true),


                                            buildTableCell(context,
                                                flexValue: 3,
                                                memberName: logic.leaderTbListOnline[index].username,
                                                heading: "Member",
                                                isContent: true,
                                                memberImage: "assets/images/dummyImg.jpg"),


                                             buildTableCell(context,
                                                flexValue: 1,
                                                textAlign: Alignment.bottomLeft,
                                                heading: "Country",
                                                isContent: true,
                                                flag: logic.leaderTbListOnline[index].userFlag),

                                            buildTableCell(context,
                                                flexValue: 2,
                                                textAlign: Alignment.centerRight,
                                                netWorth: "\$ ${Utils.formatInternational(logic.leaderTbListOnline[index].accountBalance.toString())}",
                                                isContent: true,
                                                trainer: "1",
                                                heading: "Net Worth"),


                                            buildTableCell(context,
                                                flexValue: 2,
                                                textAlign: Alignment.centerRight,
                                                netWorth: "",
                                                isContent: true,
                                                trainer: "1",
                                                heading: "Net Worth"),


                                            buildTableCell( context,
                                                flexValue: 3,
                                                heading: (logic.state.sharedPreferencesManager.getString(AppString.userId) !=
                                                        logic.leaderTbListOnline[index].uuid)
                                                    ? "Challenge"
                                                    : '',
                                                challengeEnable: logic.leaderTbListOnline[index].disableButtonConditionally,
                                                isContent: true,
                                                isOnline: false, callBack: () async {
                                              challengeDialog(
                                                onConfirm: (value) {
                                                  Get.back();
                                                  logic.challengeRequestSend(
                                                      context, value, logic.leaderTbListOnline[index].uuid);
                                                },
                                                context: context,
                                                dataList: logic.getWagerModel.options,
                                                  title: "Send a Challenge".tr,
                                                  message: 'Click "Send Challenge" below'.tr,
                                                  confirmText: "Send Challenge");
                                            }),


                                            buildTableCell(
                                              flexValue: 1,
                                              context,
                                              textAlign: Alignment.centerLeft,
                                              heading: logic.leaderTbListOnline[index].winPercentage.toString(),
                                              isContent: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }))
                          : Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(height: 70),
                                CommonTextWidget(
                                  textAlign: TextAlign.center,
                                  heading: "No Data Found!".tr,
                                  fontSize: Utils.responsiveFontSize(context, 17.sp),
                                  fontWeight: FontWeight.w800,
                                  color: ThemeProvider.whiteColor,
                                  fontFamily: "Urbanist",
                                )
                              ],
                            ),

                  Obx(() {
                    return (logic.paginationLoader.value)
                        ? Container(margin: EdgeInsets.all(1), height: 20, width: 20, child: CircularProgressIndicator())
                        : SizedBox();
                  }),
                ],
              ),
            ),
          );
  }
}
