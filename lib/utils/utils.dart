import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trading/utils/theme.dart';

class Utils {
  static const String baseUrl = "https://google.com";
  static const String baseUrl1 = "https://google.com/";
  static const String socketUrl = "wss://google.com/";


  static const String teams = "https://google.com/terms";
  static const String policy = "https://google.com/privacy";
  static const String loginVideoUrl = "https://uploads/video/tb-welcome.mp4";



  static const String soloUrl = "https://google.com/play?social_login=false&is_mobile=true&access_token=";

  static void showProgressbar() {
    Get.dialog(
        SimpleDialog(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                CircularProgressIndicator(
                  color: ThemeProvider.primary,
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                    child: Text(
                  "Please wait..",
                  style: const TextStyle(fontFamily: 'bold'),
                )),
              ],
            )
          ],
        ),
        barrierDismissible: false);
  }

  static double responsiveFontSize(BuildContext context, double baseSize, {double maxFontSize = 32}) {
    // Return the base size directly for Android and iOS
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return baseSize;
    }

    // Get screen dimensions
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Calculate a scaling factor based on the average of width and height
    double averageDimension = (width + height) / 2;

    // Calculate font size based on the average dimension
    double calculatedFontSize = baseSize * (averageDimension / 1000).clamp(0.75, 1.5);

    // Adjust for very small screens (height less than 400)
    if (height < 400) {
      calculatedFontSize = baseSize * 0.5; // Ensure a smaller font size for very small screens
    }

    // Ensure font size does not exceed the maximum cap
    return calculatedFontSize > maxFontSize ? maxFontSize : calculatedFontSize;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Indian format (1,00,000)
  static String formatIndian(String amount) {
    final doubleAmount = double.tryParse(amount) ?? 0.0;
    final formatter = NumberFormat('#,##,###', 'en_IN');
    return formatter.format(doubleAmount);
  }

// International format (100,000)
  static String formatInternational(String amount) {
    final doubleAmount = double.tryParse(amount) ?? 0.0;
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(doubleAmount);
  }

}
