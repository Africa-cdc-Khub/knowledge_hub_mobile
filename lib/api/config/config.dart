import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  final url =
      kReleaseMode ? dotenv.env['PROD_BASE_URL'] : dotenv.env['DEV_BASE_URL'];
  String get baseUrl => url ?? '';

  static const startPage = 1;
  static const pageSize = 10;
  static const privacyPolicyUrl = 'https://khub.africacdc.org/privacy';
  static const faqsUrl = 'https://khub.africacdc.org/faqs';
}
