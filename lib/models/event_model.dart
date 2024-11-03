import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/events/event_api_model.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  int id;
  String title;
  String description;
  String venue;
  String startDate;
  String endDate;
  String organizedBy;
  double fee;
  String status;
  String? eventLink;
  String registrationLink;
  bool isOnline;
  String contactPerson;
  String bannerImage;
  int countryId;
  String createdAt;
  String updatedAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,
    required this.startDate,
    required this.endDate,
    required this.organizedBy,
    required this.fee,
    required this.status,
    this.eventLink,
    required this.registrationLink,
    required this.isOnline,
    required this.contactPerson,
    required this.bannerImage,
    required this.countryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  factory EventModel.fromApiModel(EventApiModel model) {
    return EventModel(
      id: model.id ?? -1,
      title: model.title ?? '',
      description: model.description ?? '',
      venue: model.venue ?? '',
      startDate: model.startdate ?? '',
      endDate: model.enddate ?? '',
      organizedBy: model.organized_by ?? '',
      fee: double.tryParse(model.fee ?? '0') ?? 0,
      status: model.status ?? '',
      eventLink: model.event_link,
      registrationLink: model.registration_link ?? '',
      isOnline: model.is_online == 1,
      contactPerson: model.contact_person ?? '',
      bannerImage: model.banner_image ?? '',
      countryId: model.country_id ?? -1,
      createdAt: model.created_at ?? '',
      updatedAt: model.updated_at ?? '',
    );
  }
}
