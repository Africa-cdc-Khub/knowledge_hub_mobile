// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      json['email'] as String?,
      json['photo'] as String?,
      json['organization_name'] as String?,
      (json['is_approved'] as num?)?.toInt(),
      (json['is_verified'] as num?)?.toInt(),
      json['job_title'] as String?,
      json['phone_number'] as String?,
      json['langauge'] as String?,
      (json['status'] as num?)?.toInt(),
      (json['author_id'] as num?)?.toInt(),
      json['country'] == null
          ? null
          : UserCountryApiModel.fromJson(
              json['country'] as Map<String, dynamic>),
      json['settings'] == null
          ? null
          : UserSettingsApiModel.fromJson(
              json['settings'] as Map<String, dynamic>),
      (json['preferences'] as List<dynamic>?)
          ?.map(
              (e) => UserPreferenceApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'photo': instance.photo,
      'organization_name': instance.organization_name,
      'is_approved': instance.is_approved,
      'is_verified': instance.is_verified,
      'job_title': instance.job_title,
      'phone_number': instance.phone_number,
      'langauge': instance.langauge,
      'status': instance.status,
      'author_id': instance.author_id,
      'country': instance.country,
      'settings': instance.settings,
      'preferences': instance.preferences,
    };

UserCountryApiModel _$UserCountryApiModelFromJson(Map<String, dynamic> json) =>
    UserCountryApiModel(
      (json['id'] as num?)?.toInt(),
      json['national'] as String?,
      json['name'] as String?,
      json['iso_code'] as String?,
      json['phonecode'] as String?,
      (json['region_id'] as num?)?.toInt(),
      (json['longitude'] as num?)?.toDouble(),
      (json['latitude'] as num?)?.toDouble(),
      json['color'] as String?,
    );

Map<String, dynamic> _$UserCountryApiModelToJson(
        UserCountryApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'national': instance.national,
      'name': instance.name,
      'iso_code': instance.iso_code,
      'phonecode': instance.phonecode,
      'region_id': instance.region_id,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'color': instance.color,
    };

UserSettingsApiModel _$UserSettingsApiModelFromJson(
        Map<String, dynamic> json) =>
    UserSettingsApiModel(
      (json['id'] as num?)?.toInt(),
      json['title'] as String?,
      json['site_name'] as String?,
      json['seo_keywords'] as String?,
      json['site_description'] as String?,
      json['address'] as String?,
      json['email'] as String?,
      json['phone'] as String?,
      json['language'] as String?,
      json['timezone'] as String?,
      json['primary_color'] as String?,
      json['secondary_color'] as String?,
      json['logo'] as String?,
      json['favicon'] as String?,
      json['icon_font_color'] as String?,
      json['primary_text_color'] as String?,
      json['links_active_color'] as String?,
      json['spotlight_banner'] as String?,
      json['banner_text'] as String?,
      json['slogan'] as String?,
      json['content_disclaimer'] as String?,
    );

Map<String, dynamic> _$UserSettingsApiModelToJson(
        UserSettingsApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'site_name': instance.site_name,
      'seo_keywords': instance.seo_keywords,
      'site_description': instance.site_description,
      'address': instance.address,
      'email': instance.email,
      'phone': instance.phone,
      'language': instance.language,
      'timezone': instance.timezone,
      'primary_color': instance.primary_color,
      'secondary_color': instance.secondary_color,
      'logo': instance.logo,
      'favicon': instance.favicon,
      'icon_font_color': instance.icon_font_color,
      'primary_text_color': instance.primary_text_color,
      'links_active_color': instance.links_active_color,
      'spotlight_banner': instance.spotlight_banner,
      'banner_text': instance.banner_text,
      'slogan': instance.slogan,
      'content_disclaimer': instance.content_disclaimer,
    };

UserPreferenceApiModel _$UserPreferenceApiModelFromJson(
        Map<String, dynamic> json) =>
    UserPreferenceApiModel(
      (json['id'] as num?)?.toInt(),
      json['description'] as String?,
      json['icon'] as String?,
    );

Map<String, dynamic> _$UserPreferenceApiModelToJson(
        UserPreferenceApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'icon': instance.icon,
    };
