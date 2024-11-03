import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/community/community_api_model.dart';
import 'package:khub_mobile/api/models/country/country_api_model.dart';
import 'package:khub_mobile/api/models/fileType/file_type_model.dart';
import 'package:khub_mobile/api/models/job/job_api_model.dart';
import 'package:khub_mobile/api/models/preference/preference_api_model.dart';
import 'package:khub_mobile/api/models/resource/resource_api_model.dart';

part 'UtilityResponse.g.dart';

@JsonSerializable()
class FileTypeResponse {
  int? status;
  List<FileTypeApiModel>? data;

  FileTypeResponse(this.status, this.data);

  factory FileTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$FileTypeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FileTypeResponseToJson(this);
}

@JsonSerializable()
class FileCategoryResponse {
  int? status;
  List<FileTypeApiModel>? data;

  FileCategoryResponse(this.status, this.data);

  factory FileCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$FileCategoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FileCategoryResponseToJson(this);
}

@JsonSerializable()
class PreferenceResponse {
  int? status;
  List<PreferenceApiModel>? data;

  PreferenceResponse(this.status, this.data);

  factory PreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$PreferenceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PreferenceResponseToJson(this);
}

@JsonSerializable()
class JobResponse {
  int? status;
  List<JobApiModel>? data;

  JobResponse(this.status, this.data);

  factory JobResponse.fromJson(Map<String, dynamic> json) =>
      _$JobResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JobResponseToJson(this);
}

@JsonSerializable()
class CommunityResponse {
  int? status;
  List<CommunityApiModel>? data;
  int? total;

  CommunityResponse(this.status, this.data, this.total);

  factory CommunityResponse.fromJson(Map<String, dynamic> json) =>
      _$CommunityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityResponseToJson(this);
}

@JsonSerializable()
class CountryResponse {
  int? status;
  List<CountryApiModel>? data;

  CountryResponse(this.status, this.data);

  factory CountryResponse.fromJson(Map<String, dynamic> json) =>
      _$CountryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CountryResponseToJson(this);
}

@JsonSerializable()
class ResourceTypeResponse {
  int? status;
  List<ResourceTypeApiModel>? data;

  ResourceTypeResponse(this.status, this.data);

  factory ResourceTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$ResourceTypeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResourceTypeResponseToJson(this);
}

@JsonSerializable()
class ResourceCategoryResponse {
  int? status;
  List<ResourceCategoryApiModel>? data;

  ResourceCategoryResponse(this.status, this.data);

  factory ResourceCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ResourceCategoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResourceCategoryResponseToJson(this);
}
