import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/theme/theme_model.dart';

part 'ThemesResponse.g.dart';

@JsonSerializable()
class ThemesResponse {
  int? status;
  ThemeDataResponse? data;

  ThemesResponse(this.status, this.data);

  factory ThemesResponse.fromJson(Map<String, dynamic> json) => _$ThemesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ThemesResponseToJson(this);
}

@JsonSerializable()
class ThemeDataResponse {
  List<ThemeApiModel>? data;

  ThemeDataResponse(this.data);

  factory ThemeDataResponse.fromJson(Map<String, dynamic> json) => _$ThemeDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeDataResponseToJson(this);
}