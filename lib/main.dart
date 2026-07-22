import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ip_geolocation/ip_geolocation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/firebase_options.dart';
import 'package:trading/utils/app_translation.dart';
import 'package:trading/utils/connectivity.dart';
import 'package:trading/utils/notification_service.dart';
import 'package:trading/utils/string.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/video_controller.dart';

import 'backend/helper/app_router.dart';
import 'backend/helper/init.dart';

BuildContext getContext = Get.key.currentContext!;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MainBinding().dependencies();
  Get.put(ConnectivityController());
  Get.put(VideoController());
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  await NotificationHandler().initialize(navigatorKey);
  await getFCMToken();
  await getIPLocation();
  // printKeyHash();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: ThemeProvider.primary,
      ));
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.key,
        initialRoute: AppRouter.splash,
        getPages: AppRouter.routes,
        // home: LineChartWidget(data: data),
        theme: AppThemes.light,
        darkTheme: AppThemes.dark,
        themeMode: ThemeMode.dark,
        defaultTransition: Transition.fadeIn,
        translations: AppTranslation(),
        locale: Locale('en'),
        fallbackLocale: const Locale('en'),
        builder: (context, child) {
          return Obx(() {
            final isConnected = Get.find<ConnectivityController>().isConnected.value;

            if (!isConnected) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!ScaffoldMessenger.of(context).mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No internet connection!")),
                );
              });
            }
            return child ?? const SizedBox.shrink();
          });
        },
      );
    });
  }
}

Future<void> printKeyHash() async {
  try {
    final ByteData keyData = await rootBundle.load('assets/jks/android_file.jks');
    final Uint8List bytes = keyData.buffer.asUint8List();
    final Digest digest = sha1.convert(bytes);
    final String keyHash = base64Encode(digest.bytes);
    debugPrint('Key Hash: $keyHash');
  } catch (e) {
    debugPrint("Error generating key hash: $e");
  }
}

Future<void> getFCMToken() async {
  try {
    final String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppString.deviceToken, token);
      debugPrint("DEVICE TOKEN: $token");
    } else {
      debugPrint("FCM token is null");
    }
  } catch (e) {
    debugPrint("Error getting FCM token: $e");
  }
}

Future<void> getIPLocation() async {
  GeolocationData geolocationData;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  geolocationData = await GeolocationAPI.getData();
  debugPrint('IP-ADDRESS: ${geolocationData.ip}');
  debugPrint('Country: ${geolocationData.country}');
  debugPrint('Latitude: ${geolocationData.lat}');
  debugPrint('Longitude: ${geolocationData.lon}');

  prefs.setString(AppString.ipAddress, geolocationData.ip ?? '');
}
