import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/subTheme/sub_theme_model.dart';

part 'SubThemeResponseModel.g.dart';

@JsonSerializable()
class SubThemeResponse {
  int? status;
  SubThemeDataResponse? data;

  SubThemeResponse(this.status, this.data);

  factory SubThemeResponse.fromJson(Map<String, dynamic> json) => _$SubThemeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SubThemeResponseToJson(this);
}

@JsonSerializable()
class SubThemeDataResponse {
  List<SubThemeApiModel>? data;

  SubThemeDataResponse(this.data);

  factory SubThemeDataResponse.fromJson(Map<String, dynamic> json) => _$SubThemeDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SubThemeDataResponseToJson(this);
}