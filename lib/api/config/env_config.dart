import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl =>
      kReleaseMode ? _getEnvVar('PROD_BASE_URL') : _getEnvVar('DEV_BASE_URL');
  static String get microsoftClientId => _getEnvVar('MICROSOFT_CLIENT_ID');
  static String get microsoftClientSecret =>
      _getEnvVar('MICROSOFT_CLIENT_SECRET');

  static const startPage = 1;
  static const pageSize = 10;
  static const privacyPolicyUrl = 'https://khub.africacdc.org/privacy';
  static const faqsUrl = 'https://khub.africacdc.org/faqs';

  static String _getEnvVar(String key) {
    final value = dotenv.env[key];
    if (value == null) {
      throw Exception('Environment variable $key is not defined');
    }
    return value;
  }
}
