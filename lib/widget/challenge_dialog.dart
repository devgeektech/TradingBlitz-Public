import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/backend/model/get_wager_model.dart';
import 'package:trading/utils/theme.dart';

import '../utils/utils.dart';
import 'commontext.dart';

void challengeDialog({
  required BuildContext context,
  String? title,
  required String message,
  String confirmText = 'OK',
  String cancelText = 'Cancel',
  required Function(String value) onConfirm,
  VoidCallback? onCancel,
  bool showCancel = true,
  List<Option>? dataList,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: StatefulBuilder(
              builder: (context, setState) => Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width / 5, vertical: 2.h),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + Get.height * .2),
                          child: Card(
                            elevation: 10,
                        margin: EdgeInsets.all(10),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.h),
                            gradient: LinearGradient(
                              colors: [ThemeProvider.buttonColor, ThemeProvider.buttonColor],
                              stops: const [0.0, 1.0],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 1.h,
                                children: [
                                  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CommonTextWidget(
                                      heading: title ?? '',
                                      fontSize: Utils.responsiveFontSize(context, 16.sp),
                                      color: ThemeProvider.whiteColor),
                                  GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Icon(
                                      Icons.close,
                                      color: ThemeProvider.whiteColor,
                                      size: 30,
                                    ),
                                  )
                                ],
                              ),
                                  Divider(color: Colors.grey.shade300),
                                  SizedBox(height: 3.h),
                                  CommonTextWidget(
                                      heading: "Entry Fee: \$1,000",
                                      fontSize: Utils.responsiveFontSize(context, 18.sp),
                                      color: ThemeProvider.whiteColor),
                                  SizedBox(height: 3.h),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      commonGradientIconTextButton(
                                          onTap: () => onConfirm("1000"),
                                          label: confirmText.tr,
                                          height: 10.h,
                                          context: context,
                                          fontSize: Utils.responsiveFontSize(context, 14.sp)),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
          ));
}

Widget commonGradientIconTextButton({
  required BuildContext context,
  required String label,
  double? width,
  double? height,
  double? borderRadius,
  List<Color>? gradientColors,
  double? fontSize,
  FontWeight? fontWeight,
  Color? textColor,
  VoidCallback? onTap,
  String? fontFamily,
  bool isLoading = false
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      height: height ?? 28.h,
      width: width ?? 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 2.h),
        boxShadow: [
          BoxShadow(
            color: ThemeProvider.primary.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(3, 3), // changes position of shadow
          ),
          BoxShadow(
            color: ThemeProvider.primary.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(4, 4), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          colors: gradientColors ?? [ThemeProvider.primary, ThemeProvider.primary],
          stops: const [0.0, 1.0],
        ),
      ),
      child: isLoading
          ? SizedBox(
          height: 15, width: 15,
          child: CircularProgressIndicator(strokeWidth: 2,))
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: CommonTextWidget(
              textAlign: TextAlign.center,
              heading: label,
              fontSize: fontSize ?? Utils.responsiveFontSize(context, 22.sp),
              fontWeight: fontWeight ?? FontWeight.w700,
              color: textColor ?? ThemeProvider.whiteColor,
              fontFamily: fontFamily ?? "Urbanist",
            ),
          ),
        ],
      ),
    ),
  );
}
