import 'package:dio/dio.dart';
import 'package:khub_mobile/api/controllers/api_client.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/api/models/responses/NotificationsResponse.dart';
import 'package:khub_mobile/repository/api_client_repository.dart';
import 'package:khub_mobile/utils/helpers.dart';

abstract class NotificationRepository {
  Future<DataState<NotificationsResponse>> fetchNotifications();
  Future<DataState<int>> getUnreadNotificationCount();
  Future<DataState<dynamic>> markAllNotificationsAsRead(List<int> unreadIds);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiClientRepository apiClientRepository;

  NotificationRepositoryImpl({required this.apiClientRepository});

  APIClient _apiClient() {
    return apiClientRepository.buildClient();
  }

  @override
  Future<DataState<dynamic>> markAllNotificationsAsRead(
      List<int> unreadIds) async {
    try {
      final request = {
        'ids': unreadIds.toString(),
      };
      final response = await _apiClient().markAllNotificationsAsRead(request);
      return DataSuccess(response);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<NotificationsResponse>> fetchNotifications() async {
    try {
      // final result = await service.getObject('assets/data/notifications.json');
      // LOGGER.i(result);
      // final response = NotificationsResponse.fromJson(result);
      final response = await _apiClient().getNotifications({});
      return DataSuccess(response);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }

  @override
  Future<DataState<int>> getUnreadNotificationCount() async {
    try {
      final response = await _apiClient().getUnreadNotificationCount();
      return DataSuccess(response.count ?? 0);
    } on DioException catch (err) {
      return DataError(Helpers.resolveError(err));
    }
  }
}
