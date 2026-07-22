import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trading/backend/helper/app_router.dart';
import 'package:trading/utils/string.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../backend/api/api.dart';
import '../backend/model/get_wager_model.dart';
import '../widget/alert_box.dart';
import '../widget/button.dart';
import '../widget/challenge_dialog.dart';
import '../widget/common_progress.dart';
import 'api_endpoint.dart';

class WebViewOpen extends StatefulWidget {
  final String? titleName;
  final String webViewUrl;

  const WebViewOpen({super.key, required this.webViewUrl, this.titleName});

  @override
  State<WebViewOpen> createState() => _WebViewOpenState();
}

class _WebViewOpenState extends State<WebViewOpen> {
  late final WebViewController controller;
  var isLoading = true;
  GetWagerModel getWagerModel = GetWagerModel();

  @override
  void initState() {
    super.initState();

    wagerGet1(context);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(ThemeProvider.primary)
      ..enableZoom(false)
      // ..clearCache()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          debugPrint("page start ==>::  $url");
          setState(() {
            isLoading = true;
          });
        },
        onPageFinished: (url) {
          debugPrint("page End ==>::  $url");
          setState(() {
            isLoading = false;
          });
        },
        onProgress: (int progress) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ))
      ..addJavaScriptChannel('backButton',
          onMessageReceived: (JavaScriptMessage message) {
        debugPrint('JavaScript sent: ${message.message}');
        _handleBackClick(context, message.message);
      })
      ..addJavaScriptChannel('notificationLinkTrigger',
          onMessageReceived: (JavaScriptMessage message) {
        debugPrint('JavaScript sent: ${message.message}');
        _handleBackClick(context, message.message);
      })

      ..addJavaScriptChannel('challengeBridge',
          onMessageReceived: (JavaScriptMessage message) {
        debugPrint('JavaScript sent: ${message.message}');
        _handleBackClick(context, message.message);
      })
      ..addJavaScriptChannel('challengeTrigger',
          onMessageReceived: (JavaScriptMessage message) {
        debugPrint('JavaScript sent: ${message.message}');
        _handleBackClick(context, message.message);
      })
      ..loadRequest(Uri.parse(widget.webViewUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showCommonDialog(
          context: context,
          message: "".tr,
          title: "Exit to dashboard?".tr,
          onConfirm: () {
            Get.back();
          },
        );
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: ThemeProvider.primary,
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: Theme.of(context).brightness == Brightness.dark
                    ? darkThemeBackgroundGradient
                    : lightThemeBackgroundGradient,
              ),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : WebViewWidget(controller: controller),
            )),
      ),
    );
  }

  Future<void> _handleBackClick(BuildContext context, String message) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final data = jsonDecode(message);
      if (data['type'] == 'GO_BACK') {
        showCommonDialog(
          context: context,
          message: "".tr,
          title: "Exit to dashboard?".tr,
          onConfirm: () {
            Get.back();
          },
        );
      }
      else if (data['type'] == 'TRIGGER_CHALLENGE_POPUP') {
        await wagerGet1(context);
        challengeDialog(
          onConfirm: (value) {
            Get.back();
            debugPrint('WAGER-VALUE ::  $value');
            wagerApi(context, value);
          },
          context: context,
          dataList: getWagerModel.options,
            title: "Enter Challenge Queue".tr,
            message: 'Click "Enter Queue" to find someone to challenge'.tr,
            confirmText: "Enter Challenge"
        );
      }
      else if (data['type'] == 'CANCEL_CHALLENGE') {
        LoadingDialog.showLoadingDialog(context);
        var body = {
          "uuid": data['uuid'],
        };
        print('==============>>body  $body');
        var response = await ApiService.postApiWithBody(challengeCancel,
            sharedPreferences.getString(AppString.authentication) ?? '',
            body: body);
        if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
        if (response != null && response.statusCode == 200) {
          Get.back();
        }
      }
      else if(data['type'] == 'TURN_OFF_NOTIFICATIONS'){
        Get.offNamed(AppRouter.notificationScreen);
      }
    } catch (e) {
      debugPrint('Failed to parse message: $e');
    }
  }

  wagerGet1(BuildContext context) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await ApiService.getApiWithHeader(
        wagerGet, sharedPref.getString(AppString.authentication) ?? '');
    if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      getWagerModel = GetWagerModel.fromJson(myMap);
      debugPrint('RESPONSE- WAGER: ${getWagerModel.options}');
      setState(() {});
    } else {
      debugPrint('RESPONSE : $response');
    }
  }

  wagerApi(BuildContext context, String value) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    var response = await ApiService.postApiWithBody(
        challengeEnter, sharedPref.getString(AppString.authentication) ?? '',
        body: {'wager': value.toString()});
    if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      debugPrint('RESPONSE-WAGER: $myMap');
      debugPrint('RESPONSE-WAGER: ${myMap['web_url']}');
      debugPrint(
          'RESPONSE-WAGER: "${myMap['web_url']}/${sharedPref.getString(AppString.authentication)}"');
      if (myMap['web_url'] != null) {
        setState(() {
          controller.loadRequest(Uri.parse(
              "${myMap["web_url"]}?social_login=false&is_mobile=true&access_token=${sharedPref.getString(AppString.authentication)}"));
        });
      } else {
        errorToast(myMap['message']);
      }
      setState(() {});
    } else {
      debugPrint('RESPONSE : $response');
    }
  }
}
