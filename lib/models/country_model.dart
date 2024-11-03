import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/country/country_api_model.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel {
  int id;
  String national;
  String name;
  String isoCode;
  String phoneCode;
  int regionId;
  double longitude;
  double latitude;
  String color;
  String baseUrl;
  int isAppSupported;

  CountryModel({
    required this.id,
    required this.name,
    required this.national,
    required this.isoCode,
    required this.phoneCode,
    required this.regionId,
    required this.longitude,
    required this.latitude,
    required this.color,
    required this.baseUrl,
    required this.isAppSupported,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);

  factory CountryModel.fromApiModel(CountryApiModel model) {
    return CountryModel(
        id: model.id ?? -1,
        name: model.name ?? '',
        national: model.national ?? '',
        isoCode: model.iso_code ?? '',
        phoneCode: model.phonecode ?? '',
        regionId: model.region_id ?? -1,
        longitude: model.longitude ?? 0.0,
        latitude: model.latitude ?? 0.0,
        color: model.color ?? '',
        baseUrl: model.base_url ?? '',
        isAppSupported: model.is_app_supported ?? -1);
  }
}
