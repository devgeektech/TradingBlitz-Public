import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/backend/helper/app_router.dart';
import 'package:trading/utils/utils.dart';

import '../backend/api/api.dart';
import '../backend/model/get_wager_model.dart';
import '../utils/api_endpoint.dart';
import '../utils/open_web_view.dart';
import '../utils/string.dart';
import '../utils/theme.dart';
import '../utils/toast.dart';
import '../view/home/home_controller.dart';
import 'challenge_dialog.dart';
import 'commontext.dart';
import 'load_image.dart';


class ChallengeAcceptedDialog extends StatefulWidget {
  final String? title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Function(String value) onConfirm;
  final VoidCallback? onCancel;
  final bool showCancel;
  final List<Option>? dataList;
  final Map<String, dynamic>? userDetail;

  const ChallengeAcceptedDialog({
    super.key,
    this.title,
    required this.message,
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.showCancel = true,
    this.dataList,
    this.userDetail,
  });

  @override
  State<ChallengeAcceptedDialog> createState() => _ChallengeAcceptedDialogState();
}

class _ChallengeAcceptedDialogState extends State<ChallengeAcceptedDialog> {
  final TextEditingController search = TextEditingController();
  late List<Option> filteredList;
  bool show = false;
  String valuesIs = '';

  bool loader = false;

  @override
  void initState() {
    super.initState();
    filteredList = widget.dataList ?? [];
    search.text = "1000";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
           elevation: 10,
           margin: EdgeInsets.zero,
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
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               spacing: 1.h,
               children: [




                 SizedBox(height: 2.h),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     CommonTextWidget(
                         heading: widget.title ?? '',
                         fontSize: Utils.responsiveFontSize(context, 20.sp),
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
                 SizedBox(height: 1.h),
                 Column(
                   spacing: 1.h,
                   children: [
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Flexible(
                             flex: 3,
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.end,
                               spacing: 2.h,
                               children: [
                                 ClipRRect(
                                   borderRadius: BorderRadius.all(Radius.circular(100)),
                                   child: SizedBox(
                                     width: 100,
                                     height: 100,
                                     child: loadImage(image: widget.userDetail?['user_image_url'] ?? ''),
                                   ),
                                 ),
                               ],
                             )),
                         Flexible(flex: 1, child: Container()),
                         Flexible(
                             flex: 6,
                             child: Column(
                               spacing: 1.5.h,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.end,
                                   spacing: 1.w,
                                   children: [
                                     CommonTextWidget(
                                         textOverflow: TextOverflow.ellipsis,
                                         heading: widget.userDetail?['username'] ?? 'USER_NAME',
                                         fontWeight: FontWeight.w600,
                                         fontSize: Utils.responsiveFontSize(context, 20.sp),
                                         color: ThemeProvider.whiteColor),
                                     SizedBox(
                                       width: 21,
                                       height: 17,
                                       child: loadImage(image: widget.userDetail?['country'] ?? ''),
                                     ),
                                   ],
                                 ),
                                 CommonTextWidget(
                                     heading: "Account Balance: \$${Utils.formatInternational(widget.userDetail?['account_balance'] ?? "0")}",
                                     textAlign: TextAlign.start,
                                     fontSize: Utils.responsiveFontSize(context, 18.sp),
                                     color: ThemeProvider.whiteColor),
                                 // CommonTextWidget(
                                 //     heading: "Game played: ${widget.userDetail?['game_played'] ?? "0"}",
                                 //     textAlign: TextAlign.start,
                                 //     fontSize: Utils.responsiveFontSize(context, 16.sp),
                                 //     color: ThemeProvider.whiteColor),
                                 CommonTextWidget(
                                     heading: "Entry Fee: \$1,000",
                                     textAlign: TextAlign.start,
                                     fontSize: Utils.responsiveFontSize(context, 18.sp),
                                     color: ThemeProvider.whiteColor),
                               ],
                             )),
                       ],
                     ),
                   ],
                 ),

                 SizedBox(height: 1.h),
                 CommonTextWidget(
                     heading: "Who's the better trader?",
                     fontSize: Utils.responsiveFontSize(context, 21.sp),
                     color: ThemeProvider.whiteColor),
                 CommonTextWidget(
                     heading: "You'll have 90 seconds to trade the same chart.",
                     fontSize: Utils.responsiveFontSize(context, 16.sp),
                     color: ThemeProvider.whiteColor),

                 SizedBox(height: 3.h),

                 Row(
                   spacing: 1.w,
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Expanded(
                       flex: 6,
                       child: GestureDetector(
                         onTap: () {
                           Get.back();
                           Get.toNamed(AppRouter.notificationScreen);
                         },
                         child: CommonTextWidget(
                           textAlign: TextAlign.center,
                           heading: "Turn Off Notifications".tr,
                           fontSize: Utils.responsiveFontSize(context, 18.sp),
                           fontWeight: FontWeight.w900,
                           color: ThemeProvider.greyColor1,
                           fontFamily: "Urbanist",
                         ),
                       ),
                     ),

                     Expanded(
                       flex: 5,
                       child: Row(
                         spacing: 2.w,
                         children: [
                           Flexible(
                             flex: 2,
                             child: commonGradientIconTextButton(
                                 onTap: () {
                                   FocusManager.instance.primaryFocus!.unfocus();
                                    setState(() {
                                      loader = true;
                                    });
                                    Future.delayed(Duration(milliseconds: addDelay), () {
                                      if (search.text.isNotEmpty) {
                                        hitApi(context, "1000", widget.userDetail?['uuid'] ?? "");
                                        widget.onConfirm(search.text);
                                      }
                                    });
                                  },
                                  isLoading: loader,
                                  label: "Join Game".tr,
                                 fontFamily: 'bold',
                                 fontWeight: FontWeight.w900,
                                 height: 10.h,
                                 context: context,
                                 gradientColors:[
                                   ThemeProvider.buttonColor1,
                                   ThemeProvider.buttonColor1
                                 ],
                                 fontSize: Utils.responsiveFontSize(context, 17.sp)),
                           ),
                           Flexible(
                             flex: 2,
                             child: commonGradientIconTextButton(
                                 onTap: () => Get.back(),
                                 label: "Reject".tr,
                                 height: 10.h,
                                 context: context,
                                 gradientColors: [ThemeProvider.redColor, ThemeProvider.redColor],
                                 fontSize: Utils.responsiveFontSize(context, 17.sp)),
                           ),
                         ],
                       ),
                     )
                   ],
                 ),
                 SizedBox(height: 3.h),
               ],
             ),
           ),
                    ),
        ],
      ),
    );
  }

  hitApi(BuildContext context, String value, String uuid) async {
    final sharedPref = await SharedPreferences.getInstance();
    var response = await ApiService.postApiWithBody(challengeAccept, sharedPref.getString(AppString.authentication) ?? '',
        body: {'wager': value.toString(), "uuid": uuid.toString()});
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint('RESPONSE-WAGER: $myMap');
      debugPrint('RESPONSE-WAGER: ${myMap['web_url']}');
      debugPrint('RESPONSE-WAGER: "${myMap['web_url']}/${sharedPref.getString(AppString.authentication)}"');
      if (Get.isDialogOpen ?? false) { Get.back(); }
      setState(() {
        loader = false;
        if (myMap['success']) {
          Get.to(
              () => WebViewOpen(
                    webViewUrl:
                        "${Utils.baseUrl1}play?challenge=${myMap['uuid']}&social_login=false&is_mobile=true&access_token=${sharedPref.getString(AppString.authentication)}",
                    titleName: "Challenges".tr,
                  ),
              transition: Transition.downToUp);
        } else {
          errorToast(myMap['message']);
        }
      });
    }
  }
}
