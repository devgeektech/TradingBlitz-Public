
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:trading/backend/helper/api_helper.dart';

class LinkedInLogin {
  final clientId = '86nqnss0tc83az';
  final clientSecret = 'WPL_AP1.YVsrLuaArxyt0df7.5YbAcA==';
  final redirectUri = 'https://devgeektech.github.io/linkedin-redirect/redirect.html';
  final state = 'DCEeFWf45A53sdfKef424';

  final dio = Dio();

  Future<void> loginWithLinkedIn() async {
    final authUrl = Uri.https('www.linkedin.com', '/oauth/v2/authorization', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'state': state,
      'scope': 'r_liteprofile r_emailaddress',
    });

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: 'demotesting',
      );

      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];
      final stateReturned = uri.queryParameters['state'];

      if (code != null && stateReturned == state) {
        debugPrint('Authorization code: $code');
        // ⬇️ Exchange this code for access token
        await fetchAccessToken(code);
      } else {
        debugPrint('Missing code or invalid state');
      }
    } catch (e) {
      debugPrint('Login failed: $e');
    }
  }




  Future<void> fetchAccessToken(String code) async {
    try {
      final response = await dio.post(
        'https://www.linkedin.com/oauth/v2/accessToken',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Access Token: ${response.data}');
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      ApiHelper.handleError(e); // Optional centralized error handling
    }

  }
}

