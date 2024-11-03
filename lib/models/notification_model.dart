import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/notification/notification_api_model.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final int id;
  final String title;
  final String message;
  final bool read;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  factory NotificationModel.fromApiModel(NotificationApiModel apiModel) {
    return NotificationModel(
      id: apiModel.id ?? 0,
      title: apiModel.title ?? '',
      message: apiModel.message ?? '',
      read: apiModel.is_read == 1,
      createdAt: apiModel.created_at ?? '',
      updatedAt: apiModel.updated_at ?? '',
    );
  }
}
