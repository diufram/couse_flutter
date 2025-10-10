import 'package:dio/dio.dart';
import '../storage/prefs_service.dart';

class DioClient {
  final Dio dio;

  DioClient(String baseUrl, {PrefsService? prefs})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    // Logs
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    // Auth header (si hay token)
    if (prefs != null) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final token = prefs.token();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
        ),
      );
    }
  }
}
