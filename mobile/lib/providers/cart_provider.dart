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

class CartNotifier extends StateNotifier<List> {
  CartNotifier() : super(const []);

  Future<List> getCart() async {
    dio.interceptors.add(DioInterceptor());

    try {
      final Response response = await dio.get('/api/cart/');

      if (response.statusCode == 200) {
        final List all = response.data;
        state = all;
      }

      if (response.statusCode == 401) {
        throw "Not Authorized";
      }
    } on DioException catch (e) {
      throw e.message.toString();
    }

    return state;
  }

  void removeFromCart(Map product) {
    state = [
      ...state.where(
          (element) => element['product']['id'] != product['product']['id'])
    ];
  }

  void increaseQuantity(String id) {
    final updateState = [...state];
    for (var item in updateState) {
      if (item['product']['id'] == id) {
        item['quantity']++;
      }
    }
    state = updateState;
  }

  void decreaseQuantity(String id) {
    final updateState = [...state];
    for (var item in updateState) {
      if (item['product']['id'] == id) {
        item['quantity']--;
      }
    }
    state = updateState;
  }

  Future<bool> clearCart() async {
    bool shouldClear;
    try {
      final response = await dio.delete('/api/cart/clear/');
      if (response.statusCode == 200) {
        state = [];
        shouldClear = true;
      } else {
        shouldClear = false;
      }
    } on DioException catch (e) {
      e.error.toString();
      shouldClear = false;
    }
    return shouldClear;
  }
}

final userCart =
    StateNotifierProvider<CartNotifier, List>((ref) => CartNotifier());
