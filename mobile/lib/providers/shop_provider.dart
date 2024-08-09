import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/interceptors/dio.dart';

class AllProductsNotifier extends StateNotifier<List> {
  AllProductsNotifier() : super(const []);

  Future<List> getShop() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(DioInterceptor());

    try {
      final Response response = await dio.get('/api/shop/all/');

      if (response.statusCode == 200) {
        final List all = response.data;
        state = all;
      } else {
        state = [];
      }
    } on DioException catch (e) {
      e.message;
      state = [];
    }
    return state;
  }

  void refreshShop() {
    getShop();
  }
}

final allShopItems = StateNotifierProvider<AllProductsNotifier, List>(
    (ref) => AllProductsNotifier());
