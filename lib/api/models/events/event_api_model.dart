import 'package:json_annotation/json_annotation.dart';

part 'event_api_model.g.dart';

@JsonSerializable()
class EventApiModel {
  int? id;
  String? title;
  String? description;
  String? venue;
  String? startdate;
  String? enddate;
  String? organized_by;
  String? fee;
  String? status;
  String? event_link;
  String? registration_link;
  int? is_online;
  String? contact_person;
  String? banner_image;
  String? created_by;
  String? updated_by;
  int? country_id;
  String? created_at;
  String? updated_at;

  EventApiModel({
    this.id,
    this.title,
    this.description,
    this.venue,
    this.startdate,
    this.enddate,
    this.organized_by,
    this.fee,
    this.status,
    this.event_link,
    this.registration_link,
    this.is_online,
    this.contact_person,
    this.banner_image,
    this.created_by,
    this.updated_by,
    this.country_id,
    this.created_at,
    this.updated_at,
  });

  factory EventApiModel.fromJson(Map<String, dynamic> json) =>
      _$EventApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventApiModelToJson(this);
}
