import 'package:flutter/material.dart';
import 'package:khub_mobile/api/config/config.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/community_model.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/repository/communities_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class CommunityState {
  bool _loading = false;
  final bool _isSuccess = false;
  String _errorMessage = '';
  List<CommunityModel> _communities = [];
  int _currentPage = Config.startPage;
  int _totalPages = 1;
  bool _isEndOfPage = false;

  bool get loading => _loading;
  bool get isSuccess => _isSuccess;
  String get errorMessage => _errorMessage;
  List<CommunityModel> get communities => _communities;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isEndOfPage => _isEndOfPage;
}

class CommunitiesViewModel extends ChangeNotifier with SafeNotifier {
  CommunityState state = CommunityState();
  CommunityState get getState => state;

  final CommunitiesRepository communitiesRepository;
  final AuthRepository authRepository;

  CommunitiesViewModel(
      {required this.communitiesRepository, required this.authRepository});

  Future<void> fetchCommunities() async {
    state._loading = true;
    state._communities = []; // reset
    state._currentPage = Config.startPage; // reset
    state._isEndOfPage = false; // reset
    safeNotifyListeners();

    final result = await communitiesRepository.fetchCommunities();

    try {
      if (result is DataSuccess) {
        state._loading = false;
        state._totalPages = result.data?.total ?? 1;
        state._communities.addAll(result.data?.data
                ?.map((item) => CommunityModel.fromApiModel(item))
                .toList() ??
            []);
        if (result.data != null &&
            result.data!.data != null &&
            result.data!.data!.isEmpty) {
          state._isEndOfPage = true;
        }
      }

      if (result is DataError) {
        state._loading = false;
        state._errorMessage = result.error ?? 'Error';
      }
    } on Exception catch (err) {
      LOGGER.e(err);
    } finally {
      state._loading = false;
      safeNotifyListeners();
    }
  }

  Future<void> joinCommunity(int communityId) async {
    try {
      state._communities.firstWhere((c) => c.id == communityId).isLoading =
          true;
      safeNotifyListeners();

      final user = await _getCurrentUser();
      if (user == null) {
        state._errorMessage = 'User not logged in';
        safeNotifyListeners();
        return;
      }

      final result =
          await communitiesRepository.joinCommunity(communityId, user.id);

      if (result is DataSuccess) {
        LOGGER.d('joinCommunity: $result');
        state._communities
            .firstWhere((c) => c.id == communityId)
            .userPendingApproval = true;
        state._communities.firstWhere((c) => c.id == communityId).isLoading =
            false;
        safeNotifyListeners();
      }

      if (result is DataError) {
        state._errorMessage = result.error ?? 'Error';
        state._communities.firstWhere((c) => c.id == communityId).isLoading =
            false;
        safeNotifyListeners();
      }
    } catch (e) {
      LOGGER.d('joinCommunity: $e');
      state._errorMessage = e.toString();
      safeNotifyListeners();
    }
  }

  Future<void> leaveCommunity(int communityId) async {
    try {
      state._communities.firstWhere((c) => c.id == communityId).isLoading =
          true;
      state._communities.firstWhere((c) => c.id == communityId).userJoined =
          false;
      safeNotifyListeners();

      final user = await _getCurrentUser();
      if (user == null) {
        state._errorMessage = 'User not logged in';
        safeNotifyListeners();
        return;
      }

      final result =
          await communitiesRepository.leaveCommunity(communityId, user.id);

      if (result is DataSuccess) {
        LOGGER.d('joinCommunity: $result');
        state._communities.firstWhere((c) => c.id == communityId).userJoined =
            false;
        state._communities.firstWhere((c) => c.id == communityId).isLoading =
            false;
        safeNotifyListeners();
      }

      if (result is DataError) {
        state._errorMessage = result.error ?? 'Error';
        state._communities.firstWhere((c) => c.id == communityId).isLoading =
            false;
        state._communities.firstWhere((c) => c.id == communityId).userJoined =
            true; // If failed to leave, set userJoined to true
        safeNotifyListeners();
      }
    } catch (e) {
      LOGGER.d('joinCommunity: $e');
      state._errorMessage = e.toString();
      safeNotifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (state._currentPage < state._totalPages && !state._isEndOfPage) {
      try {
        final result = await communitiesRepository.fetchCommunities(
          page: ++state._currentPage,
        );

        if (result is DataSuccess) {
          state._totalPages = result.data?.total ?? 1;
          state._communities.addAll(result.data?.data
                  ?.map((item) => CommunityModel.fromApiModel(item))
                  .toList() ??
              []);
          if (result.data != null &&
              result.data!.data != null &&
              result.data!.data!.isEmpty) {
            state._isEndOfPage = true;
          }
        }

        if (result is DataError) {
          state._errorMessage = result.error ?? 'Error';
        }
      } on Exception catch (err) {
        LOGGER.e(err);
      } finally {
        state._loading = false;
        safeNotifyListeners();
      }
    }
  }

  Future<UserModel?> _getCurrentUser() async {
    final user = await authRepository.getCurrentUser();
    if (user != null) {
      return user;
    }
    return null;
  }
}
