import 'package:dio/dio.dart';
import 'package:mobile/services/store.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokens = await Store.getToken();

    options.headers['Content-type'] = 'application/json';

    if (tokens != null) {
      options.headers['Authorization'] = "Bearer ${tokens['access']}";
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final Map? tokens = await Store.getToken();

      if (tokens != null) {
        final data = {
          "refresh": tokens['refresh'],
        };
        try {
          //
          final dio = Dio(
            BaseOptions(
                baseUrl: 'http://10.0.2.2:8000',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10)),
          );

          final Response response = await dio.post(
            '/api/token/refresh/',
            data: data,
          );

          //
          if (response.statusCode == 200) {
            final Map tokens = {
              'refresh': response.data['refresh'],
              'access': response.data['access'],
            };

            await Store.setTokens(tokens);

            err.requestOptions.headers['Authorization'] =
                'Bearer ${response.data['access']}';

            handler.resolve(await dio.fetch(err.requestOptions));
          }
        } catch (e) {
          e.toString();
        }
      }
      handler.next(err);
    }
  }
}
