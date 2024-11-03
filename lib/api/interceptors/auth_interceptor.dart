import 'package:dio/dio.dart';
import 'package:khub_mobile/api/config/config.dart';
import 'package:khub_mobile/cache/preferences_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthInterceptor extends Interceptor {
  late SharedPreferences pref;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_requiresAuth(options)) {
      final token = await getSavedToken();
      final fcmToken = await getSavedFcmToken();
      LOGGER.d('FCM Token: $fcmToken');
      if (token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
      if (fcmToken.isNotEmpty) {
        options.headers["x-fcm-token"] = fcmToken;
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null) {
      final errorMsg = err.response!.data.toString();
      if (errorMsg.contains("cannot be trusted") ||
          err.response!.statusCode == 401) {
        // Token is expired or invalid, try to refresh
        final newToken = await refreshToken();
        if (newToken != null) {
          LOGGER.d('New access token: $newToken');
          // Retry the original request with the new token
          final opts = err.requestOptions;
          opts.headers["Authorization"] = "Bearer $newToken";
          final clonedRequest = await Dio().request(
            opts.path,
            options: Options(
              method: opts.method,
              headers: opts.headers,
            ),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );
          return handler.resolve(clonedRequest);
        }
      } else if (err.response!.statusCode == 403) {
        // Handle forbidden error (e.g., insufficient permissions)
        // TODO: Implement appropriate action (e.g., logout, show error message)
      }
    }
    return super.onError(err, handler);
  }

  Future<String?> refreshToken() async {
    try {
      final refreshToken = await getSavedToken();
      if (refreshToken.isEmpty) {
        LOGGER.e('No access token available');
        return null;
      }

      final baseUrl = await _getBaseUrl();
      final response = await http.get(
        Uri.parse('$baseUrl/api/refresh'),
        headers: {
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['token'] != null) {
          final newToken = responseData['token'];
          await saveToken(newToken);
          return newToken;
        }
      }

      LOGGER.e('Failed to refresh token: ${response.statusCode}');
      return null;
    } catch (e) {
      LOGGER.e('Error refreshing token: $e');
      return null;
    }
  }

  Future<void> saveToken(String newToken) async {
    pref = await SharedPreferences.getInstance();
    await pref.setString(PreferencesDatasource.accessToken, newToken);
  }

  Future<String> getSavedToken() async {
    pref = await SharedPreferences.getInstance();
    var savedToken = pref.getString(PreferencesDatasource.accessToken);

    if (savedToken != null) {
      return savedToken;
    }

    return '';
  }

  Future<String> getSavedFcmToken() async {
    pref = await SharedPreferences.getInstance();
    var savedToken = pref.getString(PreferencesDatasource.fcmTokenKey);

    if (savedToken != null) {
      return savedToken;
    }

    return '';
  }

  Future<String> _getBaseUrl() async {
    pref = await SharedPreferences.getInstance();
    final savedUrl = pref.getString(PreferencesDatasource.baseUrlKey);

    return savedUrl ?? Config().baseUrl;
  }

  Future<void> deleteSavedToken() async {
    pref = await SharedPreferences.getInstance();
    pref.remove(PreferencesDatasource.accessToken);
  }

  bool _requiresAuth(RequestOptions options) {
    return !['oauth/token', 'register'].contains(options.path);
  }
}
