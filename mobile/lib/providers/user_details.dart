import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/interceptors/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

class AllProductsNotifier extends StateNotifier<Map?> {
  AllProductsNotifier() : super(const {});

  Future<Map?> getUserDetails() async {
    dio.interceptors.add(DioInterceptor());

    try {
      final Response response = await dio.get('/api/profiles/me/');

      if (response.statusCode == 200) {
        final Map all = response.data;
        state = all;
      } else {
        state = null;
      }
    } on DioException catch (e) {
      e.message.toString();
      state = null;
    }
    return state;
  }

  Future<bool> updateProfile(Map data) async {
    dio.interceptors.add(DioInterceptor());

    try {
      final Response response =
          await dio.patch('/api/profiles/update/', data: data);

      if (response.statusCode == 200) {
        final Map all = response.data;
        state = all;
      }
      return true;
    } on DioException catch (e) {
      e.message.toString();
      return false;
    }
  }
}

final userDetail = StateNotifierProvider<AllProductsNotifier, Map?>(
    (ref) => AllProductsNotifier());
