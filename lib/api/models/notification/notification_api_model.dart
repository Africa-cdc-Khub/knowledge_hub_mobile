import 'package:json_annotation/json_annotation.dart';

part 'notification_api_model.g.dart';

@JsonSerializable()
class NotificationApiModel {
  int? id;
  String? title;
  String? message;
  int? is_read;
  String? created_at;
  String? updated_at;

  NotificationApiModel(this.id, this.title, this.message, this.is_read,
      this.created_at, this.updated_at);

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);
}
