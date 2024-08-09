import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);
