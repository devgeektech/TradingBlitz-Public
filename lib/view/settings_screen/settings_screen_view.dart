import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trading/backend/helper/app_router.dart';
import 'package:trading/utils/image_source_action_sheet.dart';
import 'package:trading/utils/app_assets.dart';
import 'package:trading/utils/open_url.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/utils.dart';
import 'package:trading/view/settings_screen/settings_screen_logic.dart';
import 'package:trading/widget/back_button.dart';
import 'package:trading/widget/button.dart';
import 'package:trading/widget/commontext.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/widget/load_image.dart';
import '../../widget/alert_box.dart';

class SettingsScreenPage extends StatefulWidget {
  const SettingsScreenPage({super.key});

  @override
  State<SettingsScreenPage> createState() => _SettingsScreenPageState();
}

class _SettingsScreenPageState extends State<SettingsScreenPage> {
  final _logic = Get.put(SettingsScreenLogic(state: Get.find()));


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logic.getProfileApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsScreenLogic>(
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
          child: SafeArea(
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
                              heading: "Settings".tr,
                              fontSize:
                                  Utils.responsiveFontSize(context, 17.sp),
                              fontWeight: FontWeight.w800,
                              color: ThemeProvider.whiteColor,
                              fontFamily: "Urbanist",
                            ),
                          ],
                        ),
                      ),
                    ],
                body: Padding(
                  padding: EdgeInsets.only(
                      left: 2.w, right: 2.w, bottom: 1.h),
                  child: Obx(() {
                    return logic.loading.value
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Color(0XFFF6F6F6),
                              borderRadius: BorderRadius.circular(5.h),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 5.w,
                              children: [
                                //Image update
                                Flexible(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Image widget
                                      Stack(
                                        children: [
                                          logic.profile.user?.picture != null &&
                                                  logic.profileImage == null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: loadImage(
                                                      image: logic.profile.user
                                                              ?.picture ??
                                                          ''))
                                              : CircleAvatar(
                                                  maxRadius: (Utils.isLandscape(
                                                          context)
                                                      ? 22.h
                                                      : 22.w),
                                                  backgroundImage: logic
                                                              .profileImage ==
                                                          null
                                                      ? AssetImage(
                                                          "assets/images/dummyImg.jpg")
                                                      : FileImage(File(
                                                          logic.profileImage!)),
                                                ),
                                          Positioned(
                                            bottom: 0.h,
                                            right: 4.w,
                                            child: InkWell(
                                              onTap: () {
                                                showCupertinoModalPopup<void>(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      ImageSourceActionSheet(
                                                    onCameraSelected: () {
                                                      logic.selectFromGallery(
                                                          context, "camera");
                                                    },
                                                    onGallerySelected: () {
                                                      logic.selectFromGallery(
                                                          context, "gallery");
                                                    },
                                                  ),
                                                );
                                              },
                                              child: CircleAvatar(
                                                maxRadius:
                                                    (Utils.isLandscape(context)
                                                        ? 5.h
                                                        : 5.w),
                                                backgroundColor:
                                                    ThemeProvider.buttonColor,
                                                child: SvgPicture.asset(
                                                  AssetPath.iconEdit,
                                                  height: (Utils.isLandscape(
                                                          context)
                                                      ? 4.h
                                                      : 4.w),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                      Column(
                                        spacing: 1.w,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonTextWidget(
                                            textAlign: TextAlign.start,
                                            heading:
                                                logic.profile.user?.username ??
                                                    'anonymous',
                                            fontSize: Utils.responsiveFontSize(
                                                context, 18.sp),
                                            fontWeight: FontWeight.w800,
                                            color: ThemeProvider.whiteColor,
                                            fontFamily: "Urbanist",
                                          ),
                                          CommonTextWidget(
                                            textAlign: TextAlign.start,
                                            heading:
                                                logic.profile.user?.email ??
                                                    'gmail.com',
                                            fontSize: Utils.responsiveFontSize(
                                                context, 16.sp),
                                            fontWeight: FontWeight.w500,
                                            color: ThemeProvider.whiteColor,
                                            fontFamily: "Urbanist",
                                          ),
                                          SizedBox(height: 1.h),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Flexible(
                                  flex: 7,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 2.w,
                                        right: 2.w,
                                        top: 4.h,
                                        bottom: 4.h),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.h),
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white10
                                            : Colors.grey.shade200),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: logic.settings
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key;
                                        var item = entry.value;
                                        return settingWidget(
                                          showDivided: index !=
                                              logic.settings.length -
                                                  1, // true for all except last
                                          title: item["title"],
                                          iconPath:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? item["lightIcon"]
                                                  : item["darkIcon"],
                                          onTap: () async {
                                            if (item["title"] ==
                                                "Account Setting".tr) {
                                              Get.toNamed(
                                                      AppRouter.updateProfile)
                                                  ?.then((value) {
                                                logic.update();
                                              });
                                            } else if (item["title"] ==
                                                "Manage Notifications".tr) {
                                              Get.toNamed(AppRouter
                                                      .notificationScreen)
                                                  ?.then((value) {
                                                logic.update();
                                              });
                                            } else if (item["title"] ==
                                                "Help Center".tr) {
                                              openUrlLauncher(
                                                  urlLink:
                                                      "https://tradingblitz.com/help");
                                            } else if (item["title"] ==
                                                "Logout".tr) {
                                              showCommonDialog(
                                                context: context,
                                                message:
                                                    "Are you sure you want to log out?"
                                                        .tr,
                                                title: "Logout".tr,
                                                onConfirm: () {
                                                  logic.logoutAcc(context);
                                                },
                                              );
                                            }
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  }),
                )),
          ),
        ),
      );
    });
  }

  Widget settingWidget(
      {String? title,
      String? iconPath,
      VoidCallback? onTap,
      required bool showDivided}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.h),
          child: SizedBox(
            height: (Utils.isLandscape(context) ? 12.h : 12.w),
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                          height: (Utils.isLandscape(context) ? 14.h : 14.w),
                          width: (Utils.isLandscape(context) ? 5.5.w : 5.5.h),
                          padding: EdgeInsets.all(
                              title == "Logout".tr ? 1.4.w : 1.5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.h),
                            color: Colors.white70,
                          ),
                          child: SvgPicture.asset(iconPath ?? ""),
                        ),
                        SizedBox(width: Utils.isLandscape(context) ? 2.w : 2.h),
                        Flexible(
                          child: CommonTextWidget(
                            textAlign: TextAlign.center,
                            heading: title ?? "",
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            fontWeight: FontWeight.w500,
                            color: ThemeProvider.whiteColor,
                            fontFamily: "Urbanist",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                    size: Utils.isLandscape(context) ? 7.h : 7.w,
                  )
                ],
              ),
            ),
          ),
        ),
        if (showDivided)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: .5.w, vertical: 0),
            child: Divider(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white38
                  : ThemeProvider.blackColor,
            ),
          ),
      ],
    );
  }
}
