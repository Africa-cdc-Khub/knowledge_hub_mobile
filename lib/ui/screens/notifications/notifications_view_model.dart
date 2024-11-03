import 'package:flutter/material.dart';
import 'package:khub_mobile/api/config/config.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/notification_model.dart';
import 'package:khub_mobile/repository/notifications_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class NotificationState {
  bool _loading = false;
  final bool _isSuccess = false;
  String _errorMessage = '';
  List<NotificationModel> _notifications = [];
  int _currentPage = Config.startPage;
  int _totalPages = 1;
  bool _isEndOfPage = false;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  List<NotificationModel> get notifications => _notifications;
}

class NotificationsViewModel extends ChangeNotifier with SafeNotifier {
  NotificationState state = NotificationState();
  NotificationState get getState => state;

  final NotificationRepository notificationRepository;

  NotificationsViewModel(this.notificationRepository);

  Future<void> fetchNotifications() async {
    state._loading = true;
    state._notifications = []; // reset
    state._currentPage = Config.startPage; // reset
    state._isEndOfPage = false; // reset
    safeNotifyListeners();

    try {
      final result = await notificationRepository.fetchNotifications();

      if (result is DataSuccess) {
        state._totalPages = result.data?.total ?? 1;
        state._notifications.addAll(result.data?.data
                ?.map((item) => NotificationModel.fromApiModel(item))
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

  Future<void> loadMore() async {
    if (state._currentPage < state._totalPages && !state._isEndOfPage) {
      try {
        final result = await notificationRepository.fetchNotifications();

        if (result is DataSuccess) {
          state._totalPages = result.data?.total ?? 1;
          state._notifications.addAll(result.data?.data
                  ?.map((item) => NotificationModel.fromApiModel(item))
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

  Future<bool> markAllNotificationsAsRead() async {
    final unreadIds = state._notifications
        .where((item) => !item.read)
        .map((item) => item.id)
        .toList();

    if (unreadIds.isNotEmpty) {
      final result =
          await notificationRepository.markAllNotificationsAsRead(unreadIds);

      if (result is DataSuccess) {
        fetchNotifications();
        return true;
      }

      if (result is DataError) {
        state._loading = false;
        state._errorMessage = result.error ?? 'Error';
        return false;
      }
    }

    return false;
  }
}
