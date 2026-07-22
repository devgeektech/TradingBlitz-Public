import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../backend/helper/app_router.dart';
import '../../backend/model/get_profile.dart';
import '../../utils/video_controller.dart';
import '../../widget/common_progress.dart';
import 'update_profile_state.dart';

class UpdateProfileLogic extends GetxController {
  final UpdateProfileState state;
  UpdateProfileLogic({required this.state});

  final VideoController videoController = Get.put(VideoController());

  GetProfileModel profile = GetProfileModel();

  XFile? selectedImage;
  String? profileImage;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> updateProfileFormKey = GlobalKey<FormState>();
  RxBool loading = false.obs;


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
      // Optional: show a snack bar or alert to inform user
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to pick image: $e')),
      // );
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
          title: 'Cropper',
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

  updateBtn(BuildContext context) {
    updateProfile(context);
  }

  updateProfile(BuildContext context) async {
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    Map<String, dynamic> body = {
      "username": userNameController.text.trim().toString(),
    };
    var response = await state.updatedProfile(body, profileImage);
    if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint("PROFILE-UPDATE :: $myMap");
      profile.fromJson(myMap);
      debugPrint("USERNAME: ${GetProfileModel().user?.username}");
      update();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }

  deleteAcc(BuildContext context) async {
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await state.deleteAccount();
    if (response != null && response.statusCode == 200) {
      navigationPage();
    } else {
      if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
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
