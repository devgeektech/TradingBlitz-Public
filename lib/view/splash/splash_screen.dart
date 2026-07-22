import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utils/app_assets.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetBuilder<SplashController>(
       builder: (value) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AssetPath.loginBg, fit: BoxFit.fill),
            Center(child: SvgPicture.asset(AssetPath.logoWithName)),
          ],
        )
      );
    });
  }
}

