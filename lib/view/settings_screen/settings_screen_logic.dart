import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:trading/utils/app_assets.dart';
import 'package:image_picker/image_picker.dart';
import '../../backend/helper/app_router.dart';
import '../../backend/model/get_profile.dart';
import '../../utils/video_controller.dart';
import '../../widget/common_progress.dart';
import 'settings_screen_state.dart';

class SettingsScreenLogic extends GetxController {
  final SettingsScreenState state;
  SettingsScreenLogic({required this.state});

  final profile = GetProfileModel();

  RxBool loading = false.obs;
  final VideoController videoController = Get.put(VideoController());
  final List<Map<String, dynamic>> settings = [
    {
      "title": "Account Setting".tr,
      "lightIcon": AssetPath.accountSettingLight,
      "darkIcon": AssetPath.accountSettingDark,
    },
    {
      "title": "Manage Notifications".tr,
      "lightIcon": AssetPath.notificationsLight,
      "darkIcon": AssetPath.notificationsDark,
    },
    {
      "title": "Help Center".tr,
      "lightIcon": AssetPath.exploreMoreLight,
      "darkIcon": AssetPath.exploreMoreDark,
    },
    {
      "title": "Logout".tr,
      "lightIcon": AssetPath.logout,
      "darkIcon": AssetPath.logout,
    },
  ];
  XFile? selectedImage;
  String? profileImage;



  void selectFromGallery(BuildContext context, String kind) async {
    try {
      loading.value = true;

      selectedImage = await ImagePicker().pickImage(
        source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 25,
      );

      if (selectedImage != null) {
        if (kind == 'camera') {
          await _cropImage(context, selectedImage!);
        }

        if (kind == 'gallery') {
          loading.value = false;
          profileImage = File(selectedImage!.path).path;
        }

        await updateProfile(context);
        update();
      } else {
        // User cancelled the picker
        loading.value = false;
      }
    } catch (e) {
      loading.value = false;
      debugPrint('Error selecting image: $e');
    }
  }

  _cropImage(BuildContext context, XFile pickedFile) async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'TradingBlitz',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.original,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'TradingBlitz',
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: false,
          rotateButtonsHidden: true,
          rotateClockwiseButtonHidden: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (croppedFile!.path.isNotEmpty) {
      profileImage = File(croppedFile.path).path;
      loading.value = false;
      updateProfile(context);
      update();
    }
  }

  updateProfile(BuildContext context) async {
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    Map<String, dynamic> body = {};
    var response = await state.updatedProfile(body, profileImage);
    if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint("PROFILE-DETAIL :: $myMap");
      profile.fromJson(myMap);
      update();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }

  logoutAcc(BuildContext context) async {
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await state.logoutAccount();
    if (response != null && response.statusCode == 200) {
      navigationPage();
    } else {
      if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
      debugPrint('RESPONSE : $response');
    }
  }

  getProfileApi(BuildContext context) async{
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await state.getProfile();
    if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      profile.fromJson(myMap);
      update();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }


  navigationPage() async {
    try {
      state.sharedPreferencesManager.clearAll();
      await videoController.initializeVideo(isLocal: true).timeout(const Duration(seconds: 5));
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        Get.toNamed(AppRouter.getLoginRoute());
      });
    } catch (e) {
      debugPrint('❌ Video failed to load: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        Get.toNamed(AppRouter.getLoginRoute());
      });
    }
  }
}
