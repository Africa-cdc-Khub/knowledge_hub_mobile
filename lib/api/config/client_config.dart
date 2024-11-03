import 'package:dio/dio.dart';

import '../interceptors/auth_interceptor.dart';

Dio initDio(String baseUrl) {
  final dio = Dio()
    ..options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 120000),
      receiveTimeout: const Duration(milliseconds: 120000),
      headers: {
        // 'Content-Type': 'application/json',
        // 'Charset': 'utf-8',
        'Accept': 'application/json'
      },
    );

  dio.interceptors.add(AuthInterceptor());

  // Add an interceptor to log requests and responses
  dio.interceptors.add(LogInterceptor(
    request: true,
    responseBody: true,
    responseHeader: true,
  ));

  return dio;
}
