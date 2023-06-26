import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();

  dio.options.baseUrl = "https://airqualitydetection.000webhostapp.com/api";

  dio.options.headers['accept'] = 'application/json';

  return dio;
}
