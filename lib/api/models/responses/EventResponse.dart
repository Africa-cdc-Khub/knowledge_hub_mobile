import 'package:khub_mobile/api/models/events/event_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'EventResponse.g.dart';

@JsonSerializable()
class EventResponse {
  int? status;
  List<EventApiModel>? data;

  EventResponse({required this.status, required this.data});

  factory EventResponse.fromJson(Map<String, dynamic> json) =>
      _$EventResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EventResponseToJson(this);
}
