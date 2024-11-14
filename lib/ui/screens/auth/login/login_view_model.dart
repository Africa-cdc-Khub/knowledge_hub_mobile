import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/cache/user_datasource.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/repository/color_theme_repository.dart';

class LoginState {
  bool isSuccess = false;
  String errorMessage = '';
  String token = '';

  LoginState();
  LoginState.success(this.isSuccess, this.token);
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

  Future<LoginState> loginWithGoogle(String accessToken) async {
    // Implement API call to your backend with Google token
    // Return LoginState based on response
    return LoginState();
  }

  Future<LoginState> loginWithMicrosoft(String accessToken) async {
    // Implement API call to your backend with Microsoft token
    // Return LoginState based on response
    return LoginState();
  }
}
