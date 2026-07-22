import 'package:dio/dio.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:trading/backend/api/post_repos.dart';
import 'package:trading/backend/api/put_repo.dart';
import 'delete_repo.dart';
import 'get_repo.dart';

class ApiService extends GetxService {
  final String appBaseUrl;
  static const String connectionIssue = 'Connection failed!';
  final int timeoutInSeconds = 120;
  static late final Dio dio;

  ApiService({required this.appBaseUrl}) {
    dio = Dio(BaseOptions(
      baseUrl: appBaseUrl,
      connectTimeout: Duration(seconds: timeoutInSeconds),
      receiveTimeout: Duration(seconds: timeoutInSeconds),
    ));

    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));
  }

  static Future<Response?> postApi(String endpoint, {required data}) => postData(endpoint, data);
  static Future<Response?> postApiWithoutBody(String endpoint, String authToken) => postDataWithoutBody(endpoint, authToken);
  static Future<Response?> postApiWithBody(String endpoint, String authToken, {required body}) => postDataWithBody(endpoint, authToken,body: body);

  /////////////////////////////////////////////
  static Future<Response?> getApi(String endpoint) => getData(endpoint);

  static Future<Response?> getApiWithHeader(String endpoint, String authToken) =>
      getDataWithHeader(endpoint, authToken: authToken);

  /////////////////////////////////////////////
  static Future<Response?> deleteApi(String endpoint, {required data}) => deleteData(endpoint, data);

  static Future<Response?> deleteApiWithoutBody(String endpoint, {required String authToken}) =>
      deleteDataWithoutBody(endpoint, authToken);

  ////////////////////////////////////////////
  static Future<Response?> putApi(String endpoint, {required data}) => putData(endpoint, data);

  static Future<Response?> putApiWithImage(String endpoint, String? file, String authToken, {required data}) =>
      putDataWithImage(endpoint, data, file, authToken);
}
