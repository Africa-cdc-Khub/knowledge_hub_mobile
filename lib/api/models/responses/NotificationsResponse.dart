import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/notification/notification_api_model.dart';

part 'NotificationsResponse.g.dart';

@JsonSerializable()
class NotificationsResponse {
  int? status;
  int? total;
  List<NotificationApiModel>? data;

  NotificationsResponse(this.status, this.data, this.total);

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsResponseToJson(this);
}

@JsonSerializable()
class UnreadNotificationResponse {
  int? count;

  UnreadNotificationResponse(this.count);

  factory UnreadNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadNotificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UnreadNotificationResponseToJson(this);
}
