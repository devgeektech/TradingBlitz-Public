import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/main.dart';

import '../utils/utils.dart';

Widget loadImage({required String? image, double? size, String? placeHolder}) {
  return image != null
      ? Image.network(image,
          width: size ?? (Utils.isLandscape(getContext) ? 42.h : 42.w),
          height: size ?? (Utils.isLandscape(getContext) ? 42.h : 42.w),
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircleAvatar(maxRadius: (Utils.isLandscape(getContext) ? 22.h : 22.w), child: Center(child: CircularProgressIndicator()));
          },
          errorBuilder: (context, error, stackTrace) =>
              CircleAvatar(maxRadius: (Utils.isLandscape(getContext) ? 22.h : 22.w), backgroundImage: AssetImage(placeHolder ?? "assets/images/dummyImg.jpg")))
      : CircleAvatar(maxRadius: (Utils.isLandscape(getContext) ? 22.h : 22.w), backgroundImage: AssetImage(placeHolder ?? "assets/images/dummyImg.jpg"));
}
