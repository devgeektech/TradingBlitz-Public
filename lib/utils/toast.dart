/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V2
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2023-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void errorToast(String message, {bool isError = true}) {
  HapticFeedback.lightImpact();
  Get.showSnackbar(GetSnackBar(
    backgroundColor: isError ? Colors.red : Colors.black,
    message: message.tr,
    duration: const Duration(seconds: 1),
    snackStyle: SnackStyle.FLOATING,
    margin: EdgeInsets.symmetric(vertical: 2.w,horizontal: 10.w),
    borderRadius: 10,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  ));
}

void successToast(String message) {
  HapticFeedback.lightImpact();
  Get.showSnackbar(GetSnackBar(
    backgroundColor: Colors.green,
    message: message.tr,
    duration: const Duration(seconds: 1),
    snackStyle: SnackStyle.FLOATING,
    margin: EdgeInsets.symmetric(vertical: 2.w,horizontal: 10.w),
    borderRadius: 10,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  ));
}

