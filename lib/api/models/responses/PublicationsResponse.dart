import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/publication/publication_model.dart';

part 'PublicationsResponse.g.dart';

@JsonSerializable()
class PublicationsResponse {
  int? status;
  int? page_size;
  int? total;
  List<PublicationApiModel>? data;

  PublicationsResponse(this.status, this.page_size, this.total, this.data);

  factory PublicationsResponse.fromJson(Map<String, dynamic> json) =>
      _$PublicationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PublicationsResponseToJson(this);
}

@JsonSerializable()
class PublicationDataResponse {
  List<PublicationApiModel>? data;

  PublicationDataResponse(this.data);

  factory PublicationDataResponse.fromJson(Map<String, dynamic> json) =>
      _$PublicationDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PublicationDataResponseToJson(this);
}
