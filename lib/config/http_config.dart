import 'package:dio/dio.dart';

class HttpConfig {
  Response? response;

  var dio = Dio(BaseOptions(
    baseUrl: "http://informatikusleszek.hu/api",
    connectTimeout: 5000,
    receiveTimeout: 5000,
    headers: {Headers.acceptHeader: 'Application/json'},
  ));
}
