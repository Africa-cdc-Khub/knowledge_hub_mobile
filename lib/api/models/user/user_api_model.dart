import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel {
  int? id;
  String? name;
  String? first_name;
  String? last_name;
  String? email;
  String? photo;
  String? organization_name;
  int? is_approved;
  int? is_verified;
  String? job_title;
  String? phone_number;
  String? langauge;
  int? status;
  int? author_id;
  UserCountryApiModel? country;
  UserSettingsApiModel? settings;
  List<UserPreferenceApiModel>? preferences;

  UserApiModel(
      this.id,
      this.name,
      this.first_name,
      this.last_name,
      this.email,
      this.photo,
      this.organization_name,
      this.is_approved,
      this.is_verified,
      this.job_title,
      this.phone_number,
      this.langauge,
      this.status,
      this.author_id,
      this.country,
      this.settings,
      this.preferences);

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);
}

@JsonSerializable()
class UserCountryApiModel {
  int? id;
  String? national;
  String? name;
  String? iso_code;
  String? phonecode;
  int? region_id;
  double? longitude;
  double? latitude;
  String? color;

  UserCountryApiModel(
      this.id,
      this.national,
      this.name,
      this.iso_code,
      this.phonecode,
      this.region_id,
      this.longitude,
      this.latitude,
      this.color);

  factory UserCountryApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserCountryApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserCountryApiModelToJson(this);
}

@JsonSerializable()
class UserSettingsApiModel {
  int? id;
  String? title;
  String? site_name;
  String? seo_keywords;
  String? site_description;
  String? address;
  String? email;
  String? phone;
  String? language;
  String? timezone;
  String? primary_color;
  String? secondary_color;
  String? logo;
  String? favicon;
  String? icon_font_color;
  String? primary_text_color;
  String? links_active_color;
  String? spotlight_banner;
  String? banner_text;
  String? slogan;
  String? content_disclaimer;

  UserSettingsApiModel(
      this.id,
      this.title,
      this.site_name,
      this.seo_keywords,
      this.site_description,
      this.address,
      this.email,
      this.phone,
      this.language,
      this.timezone,
      this.primary_color,
      this.secondary_color,
      this.logo,
      this.favicon,
      this.icon_font_color,
      this.primary_text_color,
      this.links_active_color,
      this.spotlight_banner,
      this.banner_text,
      this.slogan,
      this.content_disclaimer);

  factory UserSettingsApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserSettingsApiModelToJson(this);
}

@JsonSerializable()
class UserPreferenceApiModel {
  int? id;
  String? description;
  String? icon;

  UserPreferenceApiModel(this.id, this.description, this.icon);

  factory UserPreferenceApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferenceApiModelToJson(this);
}
