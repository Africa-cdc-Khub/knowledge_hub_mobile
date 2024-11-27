import 'package:dio/dio.dart';

abstract class ConnectionRepository {
  Future<bool> checkInternetStatus();
}

class ConnectionRepositoryImpl implements ConnectionRepository {
  Dio initDio() {
    final dio = Dio()
      ..options = BaseOptions(
        baseUrl: 'https://google.com',
        connectTimeout: const Duration(milliseconds: 120000),
        receiveTimeout: const Duration(milliseconds: 120000),
      );

    // Add an interceptor to log requests and responses
    // dio.interceptors.add(LogInterceptor(
    //   request: true,
    //   responseBody: true,
    //   responseHeader: true,
    // ));

    return dio;
  }

  @override
  Future<bool> checkInternetStatus() async {
    try {
      final dio = initDio();
      final response = await dio.get('');
      // LOGGER.d(response.statusCode == 200
      //     ? 'HAS INTERNET CONNECTION'
      //     : 'NO INTERNET CONNECTION');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
