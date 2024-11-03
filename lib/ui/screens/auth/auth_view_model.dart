import 'package:flutter/material.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class AuthState {
  bool _loggedIn = false;
  UserModel? _currentUser;

  bool get isLoggedIn => _loggedIn;
  UserModel? get currentUser => _currentUser;
}

class AuthViewModel extends ChangeNotifier with SafeNotifier {
  final AuthState _state = AuthState();
  AuthState get state => _state;

  final AuthRepository authRepository;

  AuthViewModel(this.authRepository);

  Future<bool> checkLoginStatus() async {
    final status = await authRepository.isLoggedIn();
    state._loggedIn = status;
    if (state._currentUser == null) {
      await getCurrentUser();
    }
    safeNotifyListeners();
    return status;
  }

  Future<bool?> getCurrentUser() async {
    final user = await authRepository.getCurrentUser();
    state._currentUser = user;
    safeNotifyListeners();
    return user != null;
  }

  Future<bool> logout() async {
    final result = await authRepository.logout();
    if (result) {
      state._loggedIn = false;
      state._currentUser = null;
      safeNotifyListeners();
    }
    return result;
  }
}
