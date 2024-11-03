import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class ProfileState {
  bool isSuccess = false;
  // final bool _loading = false;
  String _errorMessage = '';
  // final bool _isLoggedIn = false;
  UserModel? _currentUser;

  // bool get loading => _loading;
  String get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  ProfileState();

  ProfileState.success(this.isSuccess, this._currentUser);

  ProfileState.error(this._errorMessage);
}

class ProfileViewModel extends ChangeNotifier with SafeNotifier {
  ProfileState state = ProfileState();

  ProfileState get getState => state;
  final AuthRepository authRepository;

  ProfileViewModel(this.authRepository);

  Future<bool?> getCurrentUser() async {
    final user = await authRepository.getCurrentUser();
    state._currentUser = user;
    safeNotifyListeners();
    return user != null;
  }

  Future<ProfileState> getProfile() async {
    final user = await authRepository.getCurrentUser();
    if (user == null) return ProfileState.error('User not found');
    final result = await authRepository.getRemoteProfile(user.id);

    if (result is DataSuccess && result.data != null) {
      final user = UserModel.fromApiModel(result.data!.data);
      state._currentUser = user;
      return ProfileState.success(true, user);
    }

    if (result is DataError) {
      return ProfileState.error(result.error ?? 'Something went wrong');
    }

    return ProfileState();
  }

  Future<ProfileState> updateProfile(
      {required int id,
      required String firstName,
      required String lastName,
      required String email,
      required String phoneNumber,
      required String job,
      required int countryId,
      required List<int> preferences,
      File? profilePhoto}) async {
    final result = await authRepository.updateProfile(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        job: job,
        countryId: countryId,
        preferences: preferences,
        profilePhoto: profilePhoto);

    if (result is DataSuccess && result.data != null) {
      final user = UserModel.fromApiModel(result.data!.data);
      state._currentUser = user;
      await refreshProfile(user.id);
      return ProfileState.success(true, user);
    }

    if (result is DataError) {
      return ProfileState.error(result.error ?? 'Error');
    }

    return ProfileState();
  }

  Future<void> refreshProfile(int id) async {
    try {
      final user = await authRepository.getRemoteProfile(id);
      if (user is DataSuccess && user.data != null) {
        final updatedUser = UserModel.fromApiModel(user.data!.data);
        state._currentUser = updatedUser;
        safeNotifyListeners();
      }
    } catch (e) {
      LOGGER.e(e);
    }
  }
}
