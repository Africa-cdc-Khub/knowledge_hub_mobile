import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:khub_mobile/api/controllers/auth_client.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/api/models/responses/ProfileResponse.dart';
import 'package:khub_mobile/cache/preferences_datasource.dart';
import 'package:khub_mobile/cache/user_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/token_model.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';
import 'package:khub_mobile/repository/color_theme_repository.dart';
import 'package:khub_mobile/utils/helpers.dart';

abstract class AuthRepository {
  Future<DataState<TokenModel>> login(String username, String password);

  Future<DataState<dynamic>> signup(
      {required String firstName,
      required String lastName,
      required String email,
      required String phoneNumber,
      required String job,
      required int countryId,
      required String password,
      required String confirmPassword,
      required List<int> preferences,
      File? profilePhoto});

  Future<DataState<ProfileResponse>> updateProfile(
      {required int id,
      required String firstName,
      required String lastName,
      required String phoneNumber,
      required String job,
      required String email,
      required int countryId,
      required List<int> preferences,
      File? profilePhoto});

  Future<DataState<ProfileResponse>> getRemoteProfile(int id);

  Future<bool> isLoggedIn();
  Future<void> setLoggedIn(bool value);
  Future<bool> logout();
  Future<dynamic> remoteLogout();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCurrentUser();
  Future<DataState<dynamic>> forgotPassword(String email);
  Future<DataState<TokenModel>> socialLogin(Map<String, dynamic> payload);
  Future<void> saveToken(TokenModel token);
}

class AuthRepositoryImpl implements AuthRepository {
  final PreferencesDatasource preferences;
  final ApiClientRepository apiClientRepository;
  final UserDatasource userDatasource;
  final ColorThemeRepository colorThemeRepository;

  AuthRepositoryImpl(
      {required this.preferences,
      required this.apiClientRepository,
      required this.userDatasource,
      required this.colorThemeRepository});

  AuthClient _authClient() {
    return apiClientRepository.buildAuthClient();
  }

  @override
  Future<bool> isLoggedIn() async {
    return Future.value(
        preferences.getBoolean(PreferencesDatasource.isLoggedIn));
  }

  @override
  Future<void> setLoggedIn(bool value) {
    return preferences.saveBoolean(PreferencesDatasource.isLoggedIn, value);
  }

  @override
  Future<DataState<TokenModel>> login(String username, String password) async {
    try {
      final request = {
        'username': username,
        'password': password,
      };

      final response = await _authClient().login(request);
      final result = TokenModel.fromApiModel(response);

      // Save token
      await saveToken(result);

      return DataSuccess(TokenModel.fromApiModel(response));
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<void> saveToken(TokenModel token) async {
    await preferences.saveString(
        PreferencesDatasource.accessToken, token.accessToken);
    await preferences.saveString(
        PreferencesDatasource.refreshTokenKey, token.refreshToken);
    await preferences.saveString(
        PreferencesDatasource.expiresInKey, token.expiresIn);
    await preferences.saveString(
        PreferencesDatasource.tokenTypeKey, token.tokenType);
    await setLoggedIn(token.accessToken.isNotEmpty);
  }

  @override
  Future<bool> logout() async {
    await remoteLogout();

    await userDatasource.deleteAllUsers();
    await userDatasource.deleteAllUserCountries();

    await preferences.removeKey(PreferencesDatasource.accessToken);
    await preferences.removeKey(PreferencesDatasource.refreshTokenKey);
    await preferences.removeKey(PreferencesDatasource.tokenTypeKey);
    await preferences.removeKey(PreferencesDatasource.expiresInKey);
    await preferences.removeKey(PreferencesDatasource.primaryColorKey);
    await preferences.removeKey(PreferencesDatasource.secondaryColorKey);
    await preferences.removeKey(PreferencesDatasource.fcmTokenKey);
    await setLoggedIn(false);
    return true;
  }

  @override
  Future<DataState> signup(
      {required String firstName,
      required String lastName,
      required String email,
      required String phoneNumber,
      required String job,
      required int countryId,
      required String password,
      required String confirmPassword,
      required List<int> preferences,
      File? profilePhoto}) async {
    try {
      String prefs = preferences.toString();
      final response = await _authClient().register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          job: job,
          countryId: countryId,
          password: password,
          confirmPassword: confirmPassword,
          preferences: prefs,
          profilePhoto: profilePhoto);
      // final result = TokenModel.fromApiModel(response);
      return DataSuccess(response);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final users = await userDatasource.getUsers();
      if (users.isNotEmpty) {
        UserModel user = users[0];
        final settings = await userDatasource.getUserSettings();
        if (settings.isNotEmpty) {
          user.settings = settings[0];
        }
        final country = await userDatasource.getUserCountries();
        if (country.isNotEmpty) {
          user.country = country[0];
        }
        final preferences = await userDatasource.getUserPreferences();
        if (preferences.isNotEmpty) {
          user.preferences = preferences;
        }

        return Future.value(user);
      }

      return Future.value(null);
    } on Exception catch (e) {
      LOGGER.e(e);
      return Future.value(null);
    }
  }

  @override
  Future remoteLogout() async {
    try {
      await _authClient().logout();
    } on DioException catch (e) {
      LOGGER.e(e);
    }
  }

  @override
  Future<DataState> forgotPassword(String email) async {
    try {
      final response = await _authClient().forgotPassword({'email': email});
      return DataSuccess(response);
    } on DioException catch (e) {
      return DataError(Helpers.resolveError(e));
    }
  }

  @override
  Future<DataState<ProfileResponse>> getRemoteProfile(int id) async {
    try {
      final response = await _authClient().getProfile(id);
      await saveUser(UserModel.fromApiModel(response.data));
      return DataSuccess(response);
    } on DioException catch (e) {
      return DataError(Helpers.resolveError(e));
    }
  }

  @override
  Future<DataState<ProfileResponse>> updateProfile(
      {required int id,
      required String firstName,
      required String lastName,
      required String phoneNumber,
      required String job,
      required String email,
      required int countryId,
      required List<int> preferences,
      File? profilePhoto}) async {
    try {
      String prefs = preferences.toString();
      final response = await _authClient().updateProfile(
          id: id,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          job: job,
          email: email,
          countryId: countryId,
          preferences: prefs,
          profilePhoto: profilePhoto);
      return DataSuccess(response);
    } on DioException catch (e) {
      return DataError(Helpers.resolveError(e));
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      if (user.country != null) {
        await userDatasource.saveUserCountry(user.country!);
      }

      if (user.preferences != null) {
        await userDatasource.saveUserPreferences(user.preferences!);
      }

      if (user.settings != null) {
        final settings = user.settings!;
        await userDatasource.saveUserSetting(settings);
        await colorThemeRepository.saveThemeColors(
            settings.primaryColor, settings.primaryColor);
      }

      await userDatasource.saveUser(user);
    } on Exception catch (e) {
      LOGGER.e(e);
    }
  }

  @override
  Future<DataState<TokenModel>> socialLogin(
      Map<String, dynamic> payload) async {
    try {
      final response = await _authClient().socialLogin(payload);

      final token = TokenModel.fromApiModel(response);

      // Save token
      await saveToken(token);

      return DataSuccess(token);
    } on DioException catch (e) {
      return DataError(Helpers.resolveError(e));
    }
  }
}
