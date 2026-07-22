
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ip_geolocation/ip_geolocation.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:trading/backend/model/linked_in_model.dart';
import 'package:trading/utils/string.dart';
import 'package:trading/view/login/login_parser.dart';
import '../../backend/helper/app_router.dart';
import 'package:flutter/material.dart';
import '../../utils/toast.dart';
import '../../widget/common_progress.dart';

class LoginController extends GetxController {
  final LoginParser parser;

  LoginController({required this.parser});

  String redirectUrl = 'XXXXXXXXXXXXXXXXXXXXXXXXXXX';
  String clientId = 'XXXXXXXXXXXXXXXXX';
  String clientSecret = 'XXXXXXXXXXXXXXXXXXX';
  UserObject? user;
  bool logoutUser = false;

  loginWithLinkedIn(BuildContext context) {
    logoutUser = true;

    // sdk modification... class linkedin_login_page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LinkedInUserWidget(
          appBar: AppBar(title: Text('Sign in with LinkedIn'.tr)),
          redirectUrl: redirectUrl,
          clientId: clientId,
          clientSecret: clientSecret,
          destroySession: true,
          scope: const [
            OpenIdScope(),
            EmailScope(),
            ProfileScope(),
          ],
          onError: (UserFailedAction e) {
            debugPrint('LinkedIn Error: ${e.toString()}');
            debugPrint('Stacktrace: ${e.stackTrace}');
          },
          onGetUserProfile: (UserSucceededAction linkedInUser) {
            debugPrint('Access token: ${linkedInUser.user.token.accessToken}');
            debugPrint('First name: ${linkedInUser.user.givenName}');
            debugPrint('Last name: ${linkedInUser.user.familyName}');
            debugPrint('Email: ${linkedInUser.user.email}');
            debugPrint('Picture: ${linkedInUser.user.picture}');

            user = UserObject(
              firstName: linkedInUser.user.givenName,
              lastName: linkedInUser.user.familyName,
              email: linkedInUser.user.email,
              profileImageUrl: linkedInUser.user.picture,
            );
            logoutUser = false;
            Get.back();

            if (linkedInUser.user.token.accessToken != null) {
              if (context.mounted) {
                loginApi(
                    context: context,
                    token: linkedInUser.user.token.accessToken ?? '',
                    loginType: "linkedIn",
                    email: linkedInUser.user.email,
                    username: linkedInUser.user.givenName);
              }
            } else {
              errorToast('Error signing in with LinkedIn'.tr);
            }
          },
        ),
      ),
    );
  }

  loginWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        debugPrint('googleSignInAccount $googleSignInAccount');
        return;
      }
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      debugPrint('googleSignInAuthentication $googleSignInAuthentication');
      if (context.mounted) LoadingDialog.showLoadingDialog(context);

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      final idToken = await user?.getIdToken(true);

      debugPrint("Google user: $user");
      debugPrint("Google idToken: $idToken");
      if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
      if (user != null) {
        if (context.mounted) loginApi(context: context, token: idToken ?? '', loginType: "google");
      } else {
        errorToast('Error signing in with Google'.tr);
      }
    } catch (error) {
      errorToast('${'Error signing in with Google'.tr}$error');
    }
  }

  loginWithFaceBook(BuildContext context) async {
    try {
      final rawNonce = generateNonce();
      final nonce = parser.sha256ofString(rawNonce);
      LoginResult result;

      await FacebookAuth.instance.logOut();

      if (Platform.isAndroid) {
        result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile'], loginBehavior: LoginBehavior.webOnly);
      } else {
        result = await FacebookAuth.instance.login(loginBehavior: LoginBehavior.webOnly, permissions: ['email', 'public_profile'], nonce: nonce);
      }

      LoadingDialog.showLoadingDialog(context);

      if (result.status == LoginStatus.success && result.accessToken != null) {
        debugPrint('AuthenticationFacebook iOS - Access Token: ${result.accessToken}');
        UserCredential login;
        AuthCredential credential;

        if (Platform.isAndroid) {
          final AccessToken accessToken = result.accessToken!;
          credential = FacebookAuthProvider.credential(accessToken.tokenString);
        } else {
          credential = OAuthCredential(
            providerId: 'facebook.com',
            signInMethod: 'oauth',
            idToken: result.accessToken!.tokenString,
            rawNonce: rawNonce,
          );
        }
        login = await FirebaseAuth.instance.signInWithCredential(credential);

        final User? user = login.user;
        String? idToken = await user?.getIdToken(true);
        LoadingDialog.dismissLoadingDialog(context);

        if (user != null) {
          loginApi(context: context, token: idToken!, loginType: "faceBook");
        } else {
          errorToast('Error signing in with Facebook'.tr);
        }
      } else {
        LoadingDialog.dismissLoadingDialog(context);
        debugPrint('Facebook login failed: ${result.status}');
        errorToast('Facebook login cancelled or failed'.tr);
      }
    } catch (error) {
      LoadingDialog.dismissLoadingDialog(context);
      debugPrint('Error signing in with Facebook: $error');
      errorToast('Facebook login error:'.tr + error.toString());
    }
  }

  loginWithApply(BuildContext context) async {
    try {
      final rawNonce = generateNonce();
      final hashedNonce = parser.sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      if (context.mounted) LoadingDialog.showLoadingDialog(context);
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      debugPrint("Apple Sign-In Successful: ${userCredential.user}");
      final user = userCredential.user;
      final idToken = await user?.getIdToken(true) ?? '';

      if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
      if (user != null) {
        if (context.mounted) loginApi(context: context, token: idToken, loginType: "apple");
      } else {
        errorToast('Error signing in with Apple'.tr);
      }
    } catch (e) {
      debugPrint("Apple Sign-In Failed:".tr + e.toString());
    }
  }

  loginApi(
      {required BuildContext context, required String token, required String loginType, String? email, String? username}) async {
    String? ip = parser.sharedPreferencesManager.getString(AppString.ipAddress);
    String? fcmToken = parser.sharedPreferencesManager.getString(AppString.deviceToken);

    if(fcmToken == null){
      try {
        final String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await parser.sharedPreferencesManager.putString(AppString.deviceToken, token);
          fcmToken = token;
          debugPrint("DEVICE TOKEN: $token");
        }
      } catch (e) {
        debugPrint("Error getting FCM token: $e");
      }
    }

    if(ip == null){
      GeolocationData geolocationData;
      geolocationData = await GeolocationAPI.getData();
      parser.sharedPreferencesManager.putString(AppString.ipAddress, geolocationData.ip ?? '');
      ip = geolocationData.ip ?? '' ;
    }


    final platformName = getPlatformLabel();
    debugPrint('LOGIN IP : $ip');
    if (context.mounted) LoadingDialog.showLoadingDialog(context);
    Map<String, dynamic> body = {
      "id_token": token,
      "device_type": platformName,
      "device_id": fcmToken,
      "geolocation_ip": ip,
      "login_type": loginType
    };

    if (loginType == "linkedIn") {
      body["lin_name"] = username;
      body["lin_email"] = email;
    }

    var response = await parser.loginWithEmail(body);
    if (context.mounted) LoadingDialog.dismissLoadingDialog(context);
    update();
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.data);
      //SAVE DATA
      debugPrint("auth :: ${myMap["access_token"]}");
      parser.saveData(myMap["access_token"], myMap["user"]["uuid"]);
      navigatePage();
    } else {
      debugPrint('RESPONSE : $response');
    }
  }

  String getPlatformLabel() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else {
      return 'Unknown';
    }
  }

  navigatePage() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]).then((value) {
        Get.offAllNamed(AppRouter.getHomeRoute());
      });
    });
  }

  validateLinkedInToken(String accessToken) async {
    final url = 'https://api.linkedin.com/v2/me';


    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      debugPrint('✅ LinkedIn response: ${response.data}');

      if (response.statusCode == 200) {
        debugPrint('✅ Token is valid. User ID: ${response.data['id']}');
      } else {
        debugPrint('❌ Invalid token. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ LinkedIn API Error: $e');
    }
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    });
  }
}
