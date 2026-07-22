import 'package:flutter/material.dart';
import 'package:get/get.dart';
 import 'package:get/get_utils/get_utils.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/utils.dart';
import 'package:trading/widget/commontext.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/widget/load_image.dart';
import '../view/home/home_controller.dart';

Widget buildTableCell(BuildContext context,{
  String? heading,
  bool? isContent,
  String? memberName,
  String? memberImage,
  String? flag,
  String? netWorth,
  String? challengeValue,
  String? wonPercentage,
  int? flexValue,
  String? trainer,
  Alignment? textAlign,
  bool challengeEnable = true,
  bool?isOnline,Function? callBack}) {
  Widget child;

  if (heading == "Member" && isContent == true) {
    child = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: loadImage(image: memberImage,size: 20)
          ),
        ),
        SizedBox(width: 1.w),
        Expanded(child: _commonText(context,memberName ?? "",textAlign: textAlign)),
        // SizedBox(width: 1.w),
      ],
    );
  } else if (heading == "Country" && isContent == true) {
    child = Align(
      alignment: textAlign ?? Alignment.centerLeft,
      child: SizedBox(
        height: 4.h,
        width: 3.w,
        child: loadImage(image: flag,size: 5,placeHolder: 'assets/images/flag.png'),
      ),
    );
  } else if (heading == "Challenge" && isContent == true) {
    if(isOnline == true){
      child = _commonText(context,challengeValue ?? "-",textAlign: textAlign);
    }else{
      child = GestureDetector(
        onTap: () {
          if(!challengeEnable && !disableChallenge) { callBack!(); }
        },
        child: Container(
            height: 8.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.h)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: Container(
                  height: 8.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color:!challengeEnable && !disableChallenge ?  ThemeProvider.buttonColor : ThemeProvider.buttonColor.withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                  child: Center(child: _commonText(context,heading??"", color: ThemeProvider.whiteColor,textAlign: textAlign)),
                ),
              ),
            )
        ),
      );
    }
  } else if (heading == "Rank" && isContent == true) {
    child = _commonText(context,trainer ?? "-",textAlign: textAlign);
  } else if (heading == "Won %" && isContent == true) {
    child = _commonText(context,wonPercentage ?? "-",textAlign: textAlign);
  } else if (heading == "Net Worth" && isContent == true) {
    child = _commonText(context,netWorth ?? "",textAlign: textAlign);
  } else {
    child = _commonText(context,heading ?? "",textAlign: textAlign);
  }
  return Expanded(flex: flexValue ?? 1, child: child);
}


Widget _commonText(BuildContext context,String text, {Color? color,Alignment? textAlign}) {
  return Container(
    alignment: textAlign ?? Alignment.centerLeft,
    // decoration: BoxDecoration(
    //   color: Colors.red,
    //   border: Border.all(width: 1)
    // ),
    child: CommonTextWidget(
      lineHeight: 2,
      heading: text.tr,
      fontSize: Utils.responsiveFontSize(context, 14.5.sp),
      color: color ?? ThemeProvider.whiteColor,
      fontWeight: FontWeight.w600,
      fontFamily: "Urbanist",
      textOverflow: TextOverflow.ellipsis,
    ),
  );
}