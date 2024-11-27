import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/cache/user_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/token_model.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/repository/color_theme_repository.dart';

class LoginState {
  bool isSuccess = false;
  String errorMessage = '';
  String token = '';
  UserModel? user;

  LoginState();
  LoginState.success(this.isSuccess, this.token);
  LoginState.loginSuccess(this.isSuccess, this.user);
  LoginState.error(this.isSuccess, this.errorMessage);
}

class LoginViewModel extends ChangeNotifier {
  final LoginState state = LoginState();

  final AuthRepository authRepository;
  final UserDatasource userDatasource;
  final ColorThemeRepository colorThemeRepository;

  LoginViewModel(
      this.authRepository, this.userDatasource, this.colorThemeRepository);

  Future<LoginState> login(String username, String password) async {
    final result = await authRepository.login(username, password);

    if (result is DataSuccess) {
      final response = result.data!;
      if (response.user != null) {
        await authRepository.saveUser(response.user!);
      }
      return LoginState.success(true, result.data!.accessToken);
    }

    if (result is DataError) {
      return LoginState.error(false, result.error ?? '');
    }

    return LoginState();
  }

  Future<void> _saveUser(UserModel user) async {
    await authRepository.saveUser(user);
  }

  Future<void> saveToken(TokenModel token) async {
    await authRepository.saveToken(token);
  }

  Future<LoginState> socialLogin(Map<String, dynamic> payload) async {
    final result = await authRepository.socialLogin(payload);

    if (result is DataSuccess) {
      final response = result.data!;

      if (response.user != null) {
        LOGGER.d(response.user!.toJson());
        // await _saveUser(response.user!);
      }
      final user = response.user!;
      return LoginState.loginSuccess(true, user);
    }

    if (result is DataError) {
      return LoginState.error(false, result.error ?? '');
    }

    return LoginState();
  }
}
