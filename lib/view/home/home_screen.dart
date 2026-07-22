import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/backend/helper/app_router.dart';
import 'package:trading/utils/app_assets.dart';
import 'package:trading/utils/open_url.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/utils.dart';
import 'package:trading/widget/button.dart';
import 'package:trading/widget/commontext.dart';

import '../../utils/open_web_view.dart';
import '../../utils/string.dart';
import '../../utils/toast.dart';
import '../../widget/alert_box.dart';
import '../../widget/rotate_loader.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeScreenController = Get.put(HomeScreenController(parser: Get.find()));


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.microtask(() async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      });
      _homeScreenController.update();
      _homeScreenController.getDashboardApi(context);
      _homeScreenController.getProfileApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            showCommonDialog(
                context: context,
                message: "Are you sure you want to exit from the app?".tr,
                title: "Exit".tr,
                onConfirm: () {
                  exit(0);
                });
          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: Theme
                        .of(context)
                        .brightness == Brightness.dark
                        ? darkThemeBackgroundGradient
                        : lightThemeBackgroundGradient,
                  ),
                  child: SafeArea(
                    right: true,
                    left: true,
                    top: true,
                    bottom: true,
                    child: ListView(
                      children: [
                        SizedBox(height: Utils.isLandscape(context) ? 5.h : 5.w),

                        // account and all online user
                        Row(
                          spacing: Utils.isLandscape(context) ? 2.w : 2.h,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() {
                              return CommonTextWidget(
                                textAlign: TextAlign.center,
                                heading:
                                "Account Balance: \$ ${controller.dashboardLoader.value ? "-" : Utils.formatInternational(
                                    controller.accountBalance)}"
                                    .tr,
                                fontSize: Utils.responsiveFontSize(context, 18.sp),
                                fontWeight: FontWeight.w900,
                                addUnderline: true,
                                color: Theme
                                    .of(context)
                                    .brightness == Brightness.dark
                                    ? ThemeProvider.whiteColor
                                    : ThemeProvider.blackColor,
                                fontFamily: "Urbanist",
                              );
                            }),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: .5.w),
                              height: 40,
                              child: VerticalDivider(
                                width: 2,
                                thickness: 2,
                                color:
                                Theme
                                    .of(context)
                                    .brightness == Brightness.dark ? Colors.white38 : ThemeProvider.blackColor,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: Utils.isLandscape(context) ? 1.w : 1.h,
                              children: [
                                Transform(
                                  transform: Matrix4.translationValues(0, -4, 0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: ThemeProvider.lightThemeBgColor1, borderRadius: BorderRadius.circular(100)),
                                          child: SvgPicture.asset("assets/icons/profile.svg",
                                              height: 12, color: ThemeProvider.buttonColor1))),
                                ),
                                Obx(() {
                                  return GestureDetector(
                                    onTap: () => Get.toNamed(AppRouter.leaderboard, arguments: 1),
                                    child: CommonTextWidget(
                                      textAlign: TextAlign.center,
                                      heading: "${controller.dashboardLoader.value ? "-" : controller.onlineUsers} Users Online"
                                          .tr,
                                      fontSize: Utils.responsiveFontSize(context, 18.sp),
                                      fontWeight: FontWeight.w900,
                                      addUnderline: true,
                                      color: Theme
                                          .of(context)
                                          .brightness == Brightness.dark
                                          ? ThemeProvider.whiteColor
                                          : ThemeProvider.blackColor,
                                      fontFamily: "Urbanist",
                                    ),
                                  );
                                }),
                                Transform(
                                  transform: Matrix4.translationValues(0, -4, 0),
                                  child: RotatingRefreshIcon(
                                    isLoading: controller.isRefresh,
                                    onTap: () async {
                                      setState(() => controller.isRefresh = true);
                                      await _homeScreenController.getDashboardApi(context);
                                      setState(() => controller.isRefresh = false);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: Utils.isLandscape(context) ? 5.h : 5.w),

                        //Solo & Challenges
                        Row(
                          spacing: Utils.isLandscape(context) ? 2.w : 2.h,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            commonGradientIconTextButton(
                              onTap: () {
                                Get.to(
                                        () =>
                                        WebViewOpen(
                                          webViewUrl:
                                          "${Utils.soloUrl}${controller.parser.sharedPreferencesManager.getString(
                                              AppString.authentication)}",
                                          titleName: "Solo".tr,
                                        ),
                                    transition: Transition.downToUp)
                                    ?.then((_) {
                                  _homeScreenController.getDashboardApi(context);
                                  // _homeScreenController.wagerGet(context);
                                });
                              },
                              label: controller.totalGamePlayed == 0 ? "Start Here".tr : "Solo".tr,
                              fontWeight: FontWeight.w900,
                              context: context,
                              fontSize: controller.totalGamePlayed == 0
                                  ? Utils.responsiveFontSize(context, 26.sp)
                                  : Utils.responsiveFontSize(context, 22.sp),
                              fontFamily: controller.totalGamePlayed == 0 ? "bold".tr : "Urbanist",
                              iconPath: AssetPath.solo,
                            ),
                            commonGradientIconTextButton(
                              onTap: () async {
                                if (disableChallenge) {
                                  errorToast(controller.challengeText);
                                } else {
                                  controller.checkAuth(context);
                                }
                              },
                              label: "Two Player".tr,
                              context: context,
                              gradientColors: disableChallenge
                                  ? [
                                ThemeProvider.buttonColor.withValues(alpha: .2),
                                ThemeProvider.buttonColor.withValues(alpha: .2)
                              ]
                                  : null,
                              iconPath: AssetPath.challenges,
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 33.sp, vertical: 2.w),
                          child: Divider(
                            thickness: 2,
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark ? Colors.white38 : ThemeProvider.blackColor,
                          ),
                        ),

                        //My stats, Leaders & Setting
                        Row(
                          spacing: 2.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            commonGradientIconTextButton(
                                onTap: () {
                                  Get.toNamed(AppRouter.performance);
                                },
                                width: Get.width / 4.65,
                                height: 14.h,
                                label: "My Stats".tr,
                                context: context,
                                iconPath: AssetPath.stats,
                                fontSize: Utils.responsiveFontSize(context, 20.sp)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: .5.w),
                              height: 40,
                              child: VerticalDivider(
                                width: 2,
                                thickness: 2,
                                color:
                                Theme
                                    .of(context)
                                    .brightness == Brightness.dark ? Colors.white38 : ThemeProvider.blackColor,
                              ),
                            ),
                            commonGradientIconTextButton(
                                onTap: () {
                                  Get.toNamed(AppRouter.leaderboard);
                                },
                                width: Get.width / 4.66,
                                height: 14.h,
                                label: "Leaders".tr,
                                context: context,
                                iconPath: AssetPath.leaders,
                                fontSize: Utils.responsiveFontSize(context, 20.sp)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: .5.w),
                              height: 40,
                              child: VerticalDivider(
                                width: 2,
                                thickness: 2,
                                color:
                                Theme
                                    .of(context)
                                    .brightness == Brightness.dark ? Colors.white38 : ThemeProvider.blackColor,
                              ),
                            ),
                            commonGradientIconTextButton(
                                onTap: () {
                                  Get.toNamed(AppRouter.settingScreen);
                                },
                                width: Get.width / 4.67,
                                height: 14.h,
                                label: "Setting".tr,
                                context: context,
                                iconPath: AssetPath.settings,
                                fontSize: Utils.responsiveFontSize(context, 20.sp)),
                          ],
                        ),

                        SizedBox(height: Utils.isLandscape(context) ? 5.h : 5.w),

                        //Heading and link widget
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: Utils.responsiveFontSize(context, 19.sp),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Urbanist",
                              color: ThemeProvider.textColor,
                            ),
                            children: [
                              TextSpan(
                                  text: "Access more options by playing on ".tr,
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .brightness == Brightness.dark
                                        ? ThemeProvider.whiteColor
                                        : ThemeProvider.blackColor,
                                    fontFamily: "Urbanist",
                                  )),
                              TextSpan(
                                text: "tradingblitz.com",
                                style: TextStyle(
                                  color: ThemeProvider.buttonColor1, // Highlight link
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Urbanist",
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    openUrlLauncher(urlLink: "https://www.tradingblitz.com");
                                  },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Utils.isLandscape(context) ? 2.h : 2.w),
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }

  Widget commonGradientIconTextButton({
    required BuildContext context,
    required String iconPath,
    required String label,
    double? width,
    double? height,
    double? borderRadius,
    List<Color>? gradientColors,
    double? fontSize,
    FontWeight? fontWeight,
    Color? textColor,
    VoidCallback? onTap,
    String? fontFamily
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? Get.width / 2.75,
        height: height ?? 28.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 2.h),
          gradient: LinearGradient(
            colors: gradientColors ?? [ThemeProvider.primary, ThemeProvider.buttonColor],
            stops: const [0.0, 1.0],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath),
            SizedBox(width: 3.5.w),
            Flexible(
              child: Column(
                spacing: Utils.isLandscape(context) ? 1.w : 1.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonTextWidget(
                    textAlign: TextAlign.center,
                    heading: label,
                    fontSize: fontSize ?? Utils.responsiveFontSize(context, 22.sp),
                    fontWeight: fontWeight ?? FontWeight.w700,
                    color: textColor ?? ThemeProvider.whiteColor,
                    fontFamily: fontFamily ?? "Urbanist",
                  ),


                  if(label == "Two Player".tr)
                    CommonTextWidget(
                      textAlign: TextAlign.center,
                      heading: "Entry Fee: \$1,000",
                      fontSize: fontSize ?? Utils.responsiveFontSize(context, 16.sp),
                      fontWeight: fontWeight ?? FontWeight.w500,
                      color: textColor ?? ThemeProvider.whiteColor,
                      fontFamily: "Urbanist",
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
