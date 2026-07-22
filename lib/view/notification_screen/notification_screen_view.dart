import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/utils.dart';
import 'package:trading/view/notification_screen/notification_screen_logic.dart';
import 'package:trading/widget/button.dart';
import 'package:trading/widget/common_toggle_switch.dart';
import 'package:trading/widget/commontext.dart';
import 'package:sizer/sizer.dart';

import '../../widget/back_button.dart';

class NotificationScreenPage extends StatefulWidget {
  const NotificationScreenPage({super.key});

  @override
  State<NotificationScreenPage> createState() => _NotificationScreenPageState();
}

class _NotificationScreenPageState extends State<NotificationScreenPage> {
  final _notificationScreenLogic = Get.put(NotificationScreenLogic(state: Get.find()));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      _notificationScreenLogic.getNotificationSetting(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationScreenLogic>(
      builder: (logic) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: Theme.of(context).brightness == Brightness.dark
                ? darkThemeBackgroundGradient
                : lightThemeBackgroundGradient,
          ),
          child:
          SafeArea(
            right: true,left: true,top: true,bottom: true,
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    pinned: false,
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title:  Row(
                      spacing: 2.w,
                      children: [
                        PopButton(onPressed: () { Get.back(); }),
                        CommonTextWidget(
                          textAlign: TextAlign.center,
                          heading: "Settings".tr,
                          fontSize: Utils.responsiveFontSize(context, 17.sp),
                          fontWeight: FontWeight.w800,
                          color: ThemeProvider.whiteColor,
                          fontFamily: "Urbanist",
                        ),
                      ],
                    ),
                  ),
                ],
                body: Padding(
                  padding: EdgeInsets.only(left: 2.w,right: 2.w,bottom: 1.h),
                  child:Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ?Colors.white10
                          :Color(0XFFF6F6F6),
                      borderRadius: BorderRadius.circular(5.h),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //Challenge Notifications
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget(
                              textAlign: TextAlign.center,
                              heading: "Challenge Notifications".tr,
                              fontSize: Utils.responsiveFontSize(
                                  context, 16.sp),
                              fontWeight: FontWeight.w500,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Urbanist",
                            ),

                            CommonToggleSwitch(
                              value: logic.isChallengeNotificationEnabled,
                              onChanged: (val) {
                                logic.isChallengeNotificationEnabled = val;
                                logic.setNotificationSetting(context);
                                logic.update();
                              },
                            ),

                          ],
                        ),

                        Divider(
                          color: Theme.of(context).brightness == Brightness.dark
                              ?Colors.white38
                              :ThemeProvider.blackColor,
                        ),

                        //Top Traders Notifications
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4.h,
                          children: [
                            CommonTextWidget(
                              textAlign: TextAlign.center,
                              heading: "Top Traders Notifications".tr,
                              fontSize: Utils.responsiveFontSize(
                                  context, 16.sp),
                              fontWeight: FontWeight.w500,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Urbanist",
                            ),
                            Row(
                              children: [
                                buildRadio(logic,'Daily'.tr),
                                SizedBox(width: 10),
                                buildRadio(logic,'Weekly'.tr),
                                SizedBox(width: 10),
                                buildRadio(logic,'Disable'.tr),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 1.h),
                        //Forum Comment Notifications
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget(
                              textAlign: TextAlign.center,
                              heading: "Forum Comment Notifications".tr,
                              fontSize: Utils.responsiveFontSize(
                                  context, 16.sp),
                              fontWeight: FontWeight.w500,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Urbanist",
                            ),

                            CommonToggleSwitch(
                              value: logic.isForumNotificationEnabled,
                              onChanged: (val) {
                                logic.isForumNotificationEnabled = val;
                                logic.setNotificationSetting(context);
                                logic.update();
                              },
                            ),

                          ],
                        ),
                        Divider(
                          color: Theme.of(context).brightness == Brightness.dark
                              ?Colors.white38
                              :ThemeProvider.blackColor,
                        ),

                        //Weekly Trending Posts Notifications
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget(
                              textAlign: TextAlign.center,
                              heading: "Weekly Trending Posts Notifications".tr,
                              fontSize: Utils.responsiveFontSize(
                                  context, 16.sp),
                              fontWeight: FontWeight.w500,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Urbanist",
                            ),

                            CommonToggleSwitch(
                              value: logic.isWeeklyPostsNotificationEnabled,
                              onChanged: (val) {
                                logic.isWeeklyPostsNotificationEnabled = val;
                                logic.setNotificationSetting(context);
                                logic.update();
                              },
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      );
    });
  }
  Widget buildRadio(NotificationScreenLogic logic,String label) {
    return Container(
      padding: EdgeInsets.only(right: 2.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.h),
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey.shade200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio<String>(
            value: label,
            groupValue: logic.selectedOption,
            onChanged: (value) {
                logic.selectedOption = value!;
                logic.setNotificationSetting(context);
                logic.update();
            },
            activeColor: ThemeProvider.whiteColor,
            fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return ThemeProvider.whiteColor;
              }
              return ThemeProvider.whiteColor;
            }),
          ),
          CommonTextWidget(
            textAlign: TextAlign.center,
            heading: label,
            fontSize: Utils.responsiveFontSize(context, 16.sp),
            fontWeight: FontWeight.w800,
            color: ThemeProvider.whiteColor,
            fontFamily: "Urbanist",
          ),
        ],
      ),
    );
  }
}
