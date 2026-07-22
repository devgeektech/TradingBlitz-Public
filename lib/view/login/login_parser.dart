import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:trading/utils/string.dart';
import '../../../backend/helper/shared_pref.dart';
import '../../backend/api/api.dart';
import '../../utils/api_endpoint.dart';


class LoginParser {

  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LoginParser({
    required this.sharedPreferencesManager,
    required this.apiService,
  });


  void saveData(String token, String uid) {
    sharedPreferencesManager.putString(AppString.authentication, token);
    sharedPreferencesManager.putString(AppString.userId, uid);
  }


  Future<Response?> loginWithEmail(dynamic body) async {

    return await ApiService.postApi(login, data: body);
  }


  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
