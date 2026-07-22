import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../utils/theme.dart';
import '../utils/utils.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool isLoading;
  final Color? color; // Optional color parameter
  final double? fontSize; // Optional font size parameter

  const Button({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.color, // Default is null, meaning it will use the default color
    this.fontSize, // Optional font size parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: (Utils.isLandscape(context) ? 12.h : 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide.none,
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            color ?? ThemeProvider.buttonColor,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          title,
          style: TextStyle(
            fontSize: fontSize ?? Utils.responsiveFontSize(context, 16.sp),
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: "Urbanist",
          ),
        ),
      ),
    );
  }
}


 LinearGradient lightThemeBackgroundGradient = LinearGradient(
  colors: [
    ThemeProvider.lightThemeBgColor1,
    ThemeProvider.lightThemeBgColor2
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
LinearGradient darkThemeBackgroundGradient = LinearGradient(
  colors: [
    ThemeProvider.primary,
    ThemeProvider.blackColor
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);