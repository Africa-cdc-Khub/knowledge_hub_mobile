import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/repository/auth_repository.dart';

class ForgotPasswordState {
  bool isSuccess = false;
  String errorMessage = '';
  String token = '';

  ForgotPasswordState();
  ForgotPasswordState.success(this.isSuccess, this.token);
  ForgotPasswordState.error(this.isSuccess, this.errorMessage);
}

class ForgotPasswordViewModel extends ChangeNotifier {
  final ForgotPasswordState _state = ForgotPasswordState();
  ForgotPasswordState get state => _state;

  final AuthRepository authRepository;

  ForgotPasswordViewModel(this.authRepository);

  Future<ForgotPasswordState> forgotPassword(String email) async {
    final result = await authRepository.forgotPassword(email);

    if (result is DataSuccess) {
      return ForgotPasswordState.success(true, 'Success');
    }

    if (result is DataError) {
      return ForgotPasswordState.error(false, result.error ?? '');
    }

    return ForgotPasswordState();
  }
}
