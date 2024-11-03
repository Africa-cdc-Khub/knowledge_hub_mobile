import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/repository/auth_repository.dart';

class SignupState {
  bool isSuccess = false;
  String errorMessage = '';
  String name = '';

  SignupState();

  SignupState.success(this.isSuccess, this.name);

  SignupState.error(this.isSuccess, this.errorMessage);
}

class SignupViewModel extends ChangeNotifier {
  late SignupState state = SignupState();

  late final AuthRepository authRepository;

  SignupViewModel(this.authRepository);

  Future<SignupState> signUp(
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
    final result = await authRepository.signup(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        job: job,
        countryId: countryId,
        password: password,
        confirmPassword: confirmPassword,
        preferences: preferences,
        profilePhoto: profilePhoto);

    if (result is DataSuccess) {
      return SignupState.success(true, 'Success');
    }

    if (result is DataError) {
      return SignupState.error(false, result.error ?? 'Error');
    }

    return SignupState();
  }
}
