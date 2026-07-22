import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/backend/api/socket_service.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/utils.dart';
import 'package:trading/widget/load_image.dart';

import '../backend/model/get_wager_model.dart';
import '../widget/challenge_dialog.dart';
import '../widget/commontext.dart';
import '../widget/custom_text_field.dart';

class SocketController extends GetxController {
  final socket = SocketService(socketUrl: Utils.socketUrl);
  var hitListenerEvent = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  void _initSocket() async {
    socket.emit('online_users', { });

    socket.on('broadcast_message', (data) {
      debugPrint('DATA_RECEIVE_FROM_SOCKET_DIALOG ::: $data');
      hitListenerEvent.value = true;
    });
  }

  resetEvent() { hitListenerEvent.value = false; }
}


/// TODO ::  challenge accept dialog
challengeAcceptedDialog({
  required BuildContext context,
  String? title,
  required String message,
  String confirmText = 'OK',
  String cancelText = 'Cancel',
  required Function(String value) onConfirm,
  VoidCallback? onCancel,
  bool showCancel = true,
  List<Option>? dataList, Map<String, dynamic>? userDetail,
}) {
  final search = TextEditingController();
  List<Option> filteredList = dataList ?? [];
  bool show = false;





  print('111111111111111111111111111111111111111 ${dataList?.length}');

  // Close existing dialog if any
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }

  Get.dialog(
    GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 5, vertical: 2.h),
          child: SingleChildScrollView(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 2.h,
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
                          Column(
                            spacing: 5.h,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      flex: 3,
                                      child: Column(
                                        spacing: 2.h,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                            child: SizedBox(
                                              width: 85,
                                              height: 85,
                                              child: loadImage(image: userDetail?['user_image_url'] ??''),
                                            ),
                                          ),
                                          CommonTextWidget(
                                            textOverflow: TextOverflow.ellipsis,
                                              heading: userDetail?['username'] ?? 'USER_NAME',
                                              fontWeight: FontWeight.w600,
                                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                                              color: ThemeProvider.whiteColor),
                                        ],
                                      )),
                                  Flexible(
                                      flex: 7,
                                      child: Column(
                                        spacing: 2.h,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Row(
                                            spacing: 1.w,
                                            children: [
                                              CommonTextWidget(
                                                  heading: userDetail?['country_name'] ??"Country",
                                                  textAlign: TextAlign.start,
                                                  fontSize: Utils.responsiveFontSize(context, 16.sp),
                                                  color: ThemeProvider.whiteColor),
                                              SizedBox(
                                                width: 25,
                                                height: 20,
                                                child: loadImage(image: userDetail?['country'] ??''),
                                              ),
                                            ],
                                          ),


                                          CommonTextWidget(
                                              heading: "Account Balance: \$${userDetail?['account_balance'] ??"0"}",
                                              textAlign: TextAlign.start,
                                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                                              color: ThemeProvider.whiteColor),
                                          CommonTextWidget(
                                              heading: "Game played: ${userDetail?['game_played'] ??"0"}",
                                              textAlign: TextAlign.start,
                                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                                              color: ThemeProvider.whiteColor),
                                          CommonTextWidget(
                                              heading: "Wager amount: ${userDetail?['wager'] ??"0"}",
                                              textAlign: TextAlign.start,
                                              fontSize: Utils.responsiveFontSize(context, 16.sp),
                                              color: ThemeProvider.whiteColor),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            spacing: 1.w,
                            children: [
                              Flexible(
                                flex: 6,
                                child: SizedBox(
                                  height: 45,
                                  child: CustomTextField(
                                    controller: search,
                                    scrollPadding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom + Get.height * .1),
                                    textInputStyle: TextStyle(
                                        color: ThemeProvider.whiteColor,
                                        fontSize: Utils.responsiveFontSize(context, 14.sp),
                                        fontFamily: 'regular',
                                        height: 1),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    hintText: "Select or Type Your Wager".tr,
                                    suffixIcon: Icon(Icons.arrow_drop_down, size: 20),
                                    onChanged: (val) {
                                      setState(() {
                                        filteredList = (dataList ?? [])
                                            .where((e) => e.text.toLowerCase().contains(val.toLowerCase()))
                                            .toList();
                                        show = true;
                                      });
                                    },
                                    ontap: () {
                                      setState(() {
                                        show = !show;
                                      });
                                    },
                                    hintStyle: TextStyle(
                                      fontSize: Utils.responsiveFontSize(context, 12.sp),
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'regular',
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) => null,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: commonGradientIconTextButton(
                                    onTap: () {
                                      if (search.text.isNotEmpty) {
                                        onConfirm(search.text);
                                      }
                                    },
                                    label: "Join Game".tr,
                                    height: 10.h,
                                    width: 5.w,
                                    context: context,
                                    gradientColors: (search.text.isNotEmpty)
                                        ? [
                                      ThemeProvider.buttonColor.withValues(alpha: .2),
                                      ThemeProvider.buttonColor.withValues(alpha: .2)
                                    ]
                                        : null,
                                    fontSize: Utils.responsiveFontSize(context, 14.sp)),
                              ),
                              Flexible(
                                flex: 2,
                                child: commonGradientIconTextButton(
                                    onTap: () => Get.back(),
                                    label: "Reject".tr,
                                    height: 10.h,
                                    width: 5.w,
                                    context: context,
                                    gradientColors: [ThemeProvider.redColor, ThemeProvider.redColor],
                                    fontSize: Utils.responsiveFontSize(context, 14.sp)),
                              ),
                            ],
                          ),




                          if (filteredList.isNotEmpty && show)
                            Container(
                              constraints: BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final item = filteredList[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                    title: Text(item.text),
                                    onTap: () {
                                      search.text = item.value.toString();
                                      show = false;
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            ),
                          SizedBox(height: 1.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

