import 'package:json_annotation/json_annotation.dart';

part 'country_api_model.g.dart';

@JsonSerializable()
class CountryApiModel {
  int? id;
  String? national;
  String? name;
  String? iso_code;
  String? phonecode;
  int? region_id;
  double? longitude;
  double? latitude;
  String? color;
  String? base_url;
  int? is_app_supported;

  CountryApiModel(
      this.id,
      this.national,
      this.name,
      this.iso_code,
      this.phonecode,
      this.region_id,
      this.longitude,
      this.latitude,
      this.color,
      this.base_url,
      this.is_app_supported);

  factory CountryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CountryApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$CountryApiModelToJson(this);
}
