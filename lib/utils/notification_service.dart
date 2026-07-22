import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/backend/helper/app_router.dart';
import 'package:trading/main.dart';
import '../widget/challenge_accepted_dialog.dart';

class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;
  NotificationHandler._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  late final GlobalKey<NavigatorState> navigatorKey;

  Future<void> initialize(GlobalKey<NavigatorState> navKey) async {
    navigatorKey = navKey;

    await Firebase.initializeApp();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification tapped');
        debugPrint('Type: ${response.notificationResponseType}');
        debugPrint('Payload: ${response.payload}');
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final payloadMap = jsonDecode(response.payload!);
            _navigateToScreen(payloadMap);
          } catch (e) {
            debugPrint('Failed to decode payload: $e');
          }
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
      const AndroidNotificationChannel(
        'channel_id',
        'Default Channel',
        description: 'This channel is used for app notifications.',
        importance: Importance.high,
      ),
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen(_onMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        debugPrint('WAY -2 (onMessageOpenedApp)');
        _navigateToScreen(message.data);
      }
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      debugPrint('WAY -3 (getInitialMessage)');
      _navigateToScreen(initialMessage.data);
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    // Optional background logic
    debugPrint('Showing local notification in background...');
  }

  void _onMessage(RemoteMessage message) {
    final notification = message.notification;
    // final android = message.notification?.android;

    final title = notification?.title ?? message.data['title'];
    final body = notification?.body ?? message.data['body'];

    debugPrint('Showing local notification in foreground...');
    _showLocalNotification(title, body, message.data);
  }

  Future<void> _showLocalNotification(String? title, String? body,Map<String, dynamic> payload) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id', 'Default Channel',
      channelDescription: 'Used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
    showChallengeDialog(payload);

    /*const NotificationDetails notificationDetails = */NotificationDetails(android: androidDetails);
    // await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: jsonEncode(payload));
  }

  void _navigateToScreen(Map<String, dynamic> payload) {
    debugPrint('Showing local notification in _navigateToScreen');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.toNamed(AppRouter.home)?.then((_) {  });
      showChallengeDialog(payload);
    });

  }

  void showChallengeDialog(Map<String, dynamic> payload) {
    final navContext = Get.key.currentContext;
    if (navContext == null) return;

      // Close existing dialog if any
      if (Get.isDialogOpen ?? false) {
        Get.back(); // closes the current dialog
      }

    String currentScreen = Get.currentRoute;
    debugPrint("📌 Current screen: $currentScreen");
    if (Get.currentRoute != "/WebViewOpen") {

      Get.dialog(
        barrierDismissible: false,
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8),
            child: ChallengeAcceptedDialog(
              title: "You've Been Challenge",
              message: "Do you want to join?",
              userDetail : payload,
              // dataList: Get.find<HomeScreenController>().getWagerModel.options,
              onConfirm: (value) {  },
            ),
          ),
        )
      );
    }
  }
}

