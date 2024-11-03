import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesDatasource {
  static const String isLoggedIn = "is_logged_in";
  static const String accessToken = "accessToken";
  static const String loggedInUser = "loggedInUser";
  static const String expiresInKey = "expiresIn";
  static const String refreshTokenKey = "refreshToken";
  static const String accessTokenKey = "accessToken";
  static const String tokenTypeKey = "tokenType";
  static const String utilitiesSyncedKey = "utilitiesSyncedKey";
  static const String primaryColorKey = 'primary_color';
  static const String secondaryColorKey = 'secondary_color';
  static const String fcmTokenKey = 'fcm_token';
  static const String baseUrlKey = 'base_url';
  static const String activeKnowledgeHubKey = 'active_knowledge_hub';

  Map<String, dynamic>? getObject(String key);

  Future<bool> saveObject(String key, Map<String, dynamic> value);

  String getString(String key);

  Future<bool> saveString(String key, String value);

  bool getBoolean(String key);

  Future<bool> saveBoolean(String key, bool value);

  int getInt(String key);

  Future<bool> saveInt(String key, int value);

  Future<bool> removeKey(String key);
}

class PreferencesDatasourceImpl implements PreferencesDatasource {
  final SharedPreferences preferences;

  PreferencesDatasourceImpl({required this.preferences});

  @override
  bool getBoolean(String key) {
    return preferences.getBool(key) ?? false;
  }

  @override
  Map<String, dynamic>? getObject(String key) {
    String? userPref = preferences.getString(key);
    return userPref == null
        ? null
        : jsonDecode(userPref) as Map<String, dynamic>;
  }

  @override
  String getString(String key) {
    return preferences.getString(key) ?? '';
  }

  @override
  Future<bool> saveBoolean(String key, bool value) {
    return preferences.setBool(key, value);
  }

  @override
  Future<bool> saveObject(String key, Map<String, dynamic> value) {
    return preferences.setString(key, jsonEncode(value));
  }

  @override
  Future<bool> saveString(String key, String value) {
    return preferences.setString(key, value);
  }

  @override
  int getInt(String key) {
    return preferences.getInt(key) ?? -1;
  }

  @override
  Future<bool> saveInt(String key, int value) {
    return preferences.setInt(key, value);
  }

  @override
  Future<bool> removeKey(String key) {
    return preferences.remove(key);
  }
}
