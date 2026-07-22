import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utils/app_assets.dart';
import '../../utils/open_url.dart';
import '../../utils/utils.dart';
import '../../utils/video_controller.dart';
import '../../widget/commontext.dart';
import 'login_controller.dart';
import 'package:sizer/sizer.dart';
import '../../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final VideoController videoController = Get.find();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return SafeArea(
        top: true,
        bottom: false,
        right: false,
        left: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AssetPath.loginBg, fit: BoxFit.fill),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      spacing: 3.h,
                      children: [
                        SvgPicture.asset(AssetPath.logoWithName),
                        CommonTextWidget(
                            heading: 'Where Trading Legends Are Born'.tr,
                            fontSize: Utils.responsiveFontSize(context, 20.sp),
                            color: ThemeProvider.whiteColor,
                            useThemeColors: false,
                            textAlign: TextAlign.center),
                        CommonTextWidget(
                            heading: 'Trade Historical Charts   \u2981 Challenge Other Players'.tr,
                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                            color: ThemeProvider.whiteColor,
                            useThemeColors: false,
                            textAlign: TextAlign.center),

                        SizedBox(height: 1.h),

                        Obx(() {
                          if (!videoController.isInitialized.value) {
                            return Container(
                              width: double.infinity,
                              height: Get.height * .3,
                              padding: EdgeInsets.all(12.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.sp),
                                color: ThemeProvider.blackColor.withValues(alpha: 0.7),
                              ),
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          }
                          return Container(
                            padding: EdgeInsets.all(12.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.sp),
                              color: ThemeProvider.blackColor.withValues(alpha: 0.7),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.sp),
                              child: AspectRatio(
                                aspectRatio: videoController.chewieController!.videoPlayerController.value.aspectRatio,
                                child: Chewie(controller: videoController.chewieController!),
                              ),
                            ),
                          );
                        }),

                        CommonTextWidget(
                            heading: 'Sign up and log in using your social accounts'.tr,
                            fontSize: Utils.responsiveFontSize(context, 17.sp),
                            color: ThemeProvider.whiteColor,
                            useThemeColors: false,
                            textAlign: TextAlign.center),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () => controller.loginWithFaceBook(context),
                                icon: Container(
                                  padding: EdgeInsets.all(13.4.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.sp),
                                    color: ThemeProvider.whiteColor,
                                  ),
                                  child: SvgPicture.asset(AssetPath.fbLogo,width: 36),
                                )),


                            IconButton(
                                onPressed: () => controller.loginWithLinkedIn(context),
                                icon: Container(
                                  padding: EdgeInsets.all(13.4.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.sp),
                                    color: ThemeProvider.whiteColor,
                                  ),
                                  child: SvgPicture.asset(AssetPath.linkedInLogo,width: 36),
                                )),
                            if (Platform.isIOS)
                              IconButton(
                                  onPressed: () => controller.loginWithApply(context),
                                  icon: Container(
                                    padding: EdgeInsets.all(13.4.sp),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.sp),
                                      color: ThemeProvider.whiteColor,
                                    ),
                                    child: SvgPicture.asset(AssetPath.appleLogo,height: 36),
                                  )),
                            IconButton(
                                onPressed: () => controller.loginWithGoogle(context),
                                icon: Container(
                                  padding: EdgeInsets.all(15.2.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.sp),
                                    color: ThemeProvider.whiteColor,
                                  ),
                                  child: SvgPicture.asset(AssetPath.googleLogo),
                                )),
                          ],
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 16.sp,
                              height: 1.6, // increases line height
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "By using Trading Blitz's Mobile App and services, you agree to our".tr,
                                style: TextStyle(
                                  color: ThemeProvider.whiteColor,
                                ),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: "Terms".tr,
                                style: TextStyle(
                                  color: ThemeProvider.whiteColor,
                                  decoration: TextDecoration.underline,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0),
                                      offset: Offset(0, -1), // lifts text up slightly
                                    ),
                                  ],
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    openUrlLauncher(urlLink: Utils.teams);
                                  },
                              ),
                              TextSpan(
                                text: "and".tr,
                                style: TextStyle(
                                  color: ThemeProvider.whiteColor,
                                ),
                              ),
                              TextSpan(
                                text: "Privacy Policy".tr,
                                style: TextStyle(
                                  color: ThemeProvider.whiteColor,
                                  decoration: TextDecoration.underline,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0),
                                      offset: Offset(0, -1),
                                    ),
                                  ],
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    openUrlLauncher(urlLink: Utils.policy);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

}
