// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      siteName: json['siteName'] as String,
      seoKeywords: json['seoKeywords'] as String,
      siteDescription: json['siteDescription'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      language: json['language'] as String,
      timezone: json['timezone'] as String,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      logo: json['logo'] as String,
      favicon: json['favicon'] as String,
      iconFontColor: json['iconFontColor'] as String,
      primaryTextColor: json['primaryTextColor'] as String,
      linksActiveColor: json['linksActiveColor'] as String,
      spotlightBanner: json['spotlightBanner'] as String,
      bannerText: json['bannerText'] as String,
      slogan: json['slogan'] as String,
      contentDisclaimer: json['contentDisclaimer'] as String,
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'siteName': instance.siteName,
      'seoKeywords': instance.seoKeywords,
      'siteDescription': instance.siteDescription,
      'address': instance.address,
      'email': instance.email,
      'phone': instance.phone,
      'language': instance.language,
      'timezone': instance.timezone,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'logo': instance.logo,
      'favicon': instance.favicon,
      'iconFontColor': instance.iconFontColor,
      'primaryTextColor': instance.primaryTextColor,
      'linksActiveColor': instance.linksActiveColor,
      'spotlightBanner': instance.spotlightBanner,
      'bannerText': instance.bannerText,
      'slogan': instance.slogan,
      'contentDisclaimer': instance.contentDisclaimer,
    };
