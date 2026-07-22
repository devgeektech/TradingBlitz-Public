import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:trading/utils/image_source_action_sheet.dart';
import 'package:trading/utils/app_assets.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/validation.dart';
import 'package:trading/view/update_profile/update_profile_logic.dart';
import 'package:trading/widget/alert_box.dart';
import 'package:trading/widget/button.dart';
import 'package:trading/widget/custom_text_field.dart';
import 'package:sizer/sizer.dart';
import '../../utils/utils.dart';
import '../../widget/back_button.dart';
import '../../widget/commontext.dart';
import '../../widget/load_image.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _updateProfileLogic = Get.put(UpdateProfileLogic(state: Get.find()));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateProfileLogic.userNameController.text = _updateProfileLogic.profile.user?.username ?? '';
      _updateProfileLogic.emailController.text = _updateProfileLogic.profile.user?.email ?? '';
      _updateProfileLogic.getProfileApi(context);
      _updateProfileLogic.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileLogic>(builder: (controller) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient:
                  Theme.of(context).brightness == Brightness.dark ? darkThemeBackgroundGradient : lightThemeBackgroundGradient,
            ),
            child: SafeArea(
              right: true,
              left: true,
              top: true,
              bottom: true,
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
                                FocusManager.instance.primaryFocus!.unfocus();
                                Get.back();
                              }),
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
                      padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 2.h),
                      child: Obx(() {
                        return controller.loading.value
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Color(0XFFF6F6F6),
                                  borderRadius: BorderRadius.circular(5.h),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5.w,
                                  children: [
                                    //Image update
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        //Image widget
                                        Stack(
                                          children: [
                                            controller.profile.user?.picture != null && controller.profileImage == null
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: loadImage(image: controller.profile.user?.picture ?? ''))
                                                : CircleAvatar(
                                                    maxRadius: (Utils.isLandscape(context) ? 22.h : 22.w),
                                                    backgroundImage: controller.profileImage == null
                                                        ? AssetImage("assets/images/dummyImg.jpg")
                                                        : FileImage(File(controller.profileImage!)),
                                                  ),
                                            Positioned(
                                              bottom: 0.h,
                                              right: 4.w,
                                              child: InkWell(
                                                onTap: () {
                                                  showCupertinoModalPopup<void>(
                                                    context: context,
                                                    builder: (BuildContext context) => ImageSourceActionSheet(
                                                      onCameraSelected: () {
                                                        controller.selectFromGallery(context, "camera");
                                                      },
                                                      onGallerySelected: () {
                                                        controller.selectFromGallery(context, "gallery");
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  maxRadius: (Utils.isLandscape(context) ? 5.h : 5.w),
                                                  backgroundColor: ThemeProvider.buttonColor,
                                                  child: SvgPicture.asset(
                                                    AssetPath.iconEdit,
                                                    height: (Utils.isLandscape(context) ? 4.h : 4.w),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),

                                        Column(
                                          spacing: 1.w,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonTextWidget(
                                              textAlign: TextAlign.start,
                                              heading: controller.profile.user?.username ?? 'anonymous',
                                              fontSize: Utils.responsiveFontSize(context, 18.sp),
                                              fontWeight: FontWeight.w800,
                                              color: ThemeProvider.whiteColor,
                                              fontFamily: "Urbanist",
                                            ),
                                            CommonTextWidget(
                                              textAlign: TextAlign.start,
                                              heading: controller.profile.user?.email ?? 'gmail.com',
                                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                                              fontWeight: FontWeight.w500,
                                              color: ThemeProvider.whiteColor,
                                              fontFamily: "Urbanist",
                                            ),
                                            SizedBox(height: 1.h),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5.h),
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? Colors.white10
                                                    : Colors.grey.shade200,
                                              ),
                                              child: Form(
                                                key: controller.updateProfileFormKey,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      spacing: 1.5.w,
                                                      children: [
                                                        CustomTextField(
                                                          scrollPadding: EdgeInsets.only(
                                                              bottom: MediaQuery.of(context).viewInsets.bottom + Get.height * .1),
                                                          controller: controller.userNameController,
                                                          textInputStyle: TextStyle(
                                                            color: ThemeProvider.textColor,
                                                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                            fontFamily: 'regular',
                                                          ),
                                                          hintText: "Username".tr,
                                                          validator: (value) {
                                                            if (value == null || value.trim().isEmpty) {
                                                              return 'Username is required'.tr;
                                                            }
                                                            if (!RegExp(r'^[a-zA-Z0-9_ ]+$').hasMatch(value)) {
                                                              return 'Username can only contain letters, numbers, underscores, and spaces';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        CustomTextField(
                                                          controller: controller.emailController,
                                                          readOnly: true,
                                                          textInputStyle: TextStyle(
                                                            color: ThemeProvider.textColor.withAlpha(120),
                                                            fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                            fontFamily: 'regular',
                                                          ),
                                                          hintText: "Email address".tr,
                                                          keyboardType: TextInputType.emailAddress,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty ||
                                                                !Validators.isEmailValid(value)) {
                                                              return 'Invalid email'.tr;
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Button(
                                                      onPressed: () {
                                                        if (controller.updateProfileFormKey.currentState!.validate()) {
                                                          controller.updateBtn(context);
                                                        }
                                                      },
                                                      title: "Update".tr,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(vertical: 3.h),
                                            child: GestureDetector(
                                              onTap: () {
                                                showCommonDialog(
                                                  context: context,
                                                  message: "Are you sure you want to delete this account?".tr,
                                                  title: "Delete Account".tr,
                                                  onConfirm: () {
                                                    controller.deleteAcc(context);
                                                  },
                                                );
                                              },
                                              child: CommonTextWidget(
                                                textAlign: TextAlign.end,
                                                heading: "Delete Account".tr,
                                                fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                fontWeight: FontWeight.w500,
                                                color: ThemeProvider.redColor1,
                                                textDecoration: TextDecoration.underline,
                                                decorationColor: ThemeProvider.redColor,
                                                fontFamily: "Urbanist",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                      }))),
            ),
          ),
        ),
      );
    });
  }
}
