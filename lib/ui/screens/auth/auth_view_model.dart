import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/services/microsoft_auth_service.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthState {
  bool _loggedIn = false;
  UserModel? _currentUser;

  String errorMessage = '';
  bool isSuccess = false;
  Map<String, dynamic> userDetails = {};

  bool get isLoggedIn => _loggedIn;
  UserModel? get currentUser => _currentUser;

  AuthState();
  AuthState.microsoftSignIn(this.isSuccess, this.userDetails);
  AuthState.googleSignIn(this.isSuccess, this.userDetails);
  AuthState.error(this.isSuccess, this.errorMessage);
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

  Future<Map<String, dynamic>> fetchAzureUserDetails(String accessToken) async {
    LOGGER.d('Fetching Azure user details');
    http.Response response;
    response = await http.get(
      Uri.parse("https://graph.microsoft.com/v1.0/me"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return json.decode(response.body);
  }

  Future<AuthState> microsoftSignIn() async {
    try {
      final result = await MicrosoftAuthService().oauth.login();

      return result.fold(
        (error) {
          LOGGER.e(error);
          return AuthState.error(false, error.message);
        },
        (token) async {
          LOGGER.d('Token: ${token.accessToken}');
          final result = await fetchAzureUserDetails(token.accessToken!);
          result['provider'] = 'microsoft';
          LOGGER.d(result);
          return AuthState.microsoftSignIn(true, result);
        },
      );
    } catch (error) {
      LOGGER.e(error);
      return AuthState.error(false, 'Microsoft sign in failed');
    }
  }

  Future<AuthState> googleSignIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Obtain the Google Access Token
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential for the user
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase using the credential
        await FirebaseAuth.instance.signInWithCredential(credential);

        final user = {
          'accessToken': googleAuth.accessToken,
          'idToken': googleAuth.idToken,
          'email': googleUser.email,
          'name': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
          'providerId': googleUser.id,
          'provider': 'google',
        };
        return AuthState.googleSignIn(true, user);
      }

      return AuthState.error(false, 'Google sign in failed');
    } catch (error) {
      LOGGER.e(error);
      return AuthState.error(false, 'Google sign in failed');
    }
  }
}
