
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/utils/theme.dart';

import '../utils/app_assets.dart';

class PopButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? size;
  final Color? color;
  final double? fontSize;

  const PopButton({
    super.key,
    required this.onPressed,
    this.color,
    this.size =40,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
        width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed, icon: Container(
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: ThemeProvider.whiteColor,
          border: Border.all(color: ThemeProvider.buttonColor.withValues(alpha: .6),width: 2)
        ),
        child: SvgPicture.asset(
          AssetPath.arrowBack,
        ),
      ),)
    );
  }
}