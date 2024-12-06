// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      photo: json['photo'] as String,
      organizationName: json['organizationName'] as String,
      isApproved: (json['isApproved'] as num).toInt(),
      isVerified: (json['isVerified'] as num).toInt(),
      jobTitle: json['jobTitle'] as String,
      phoneNumber: json['phoneNumber'] as String,
      language: json['language'] as String,
      status: (json['status'] as num).toInt(),
      authorId: (json['authorId'] as num).toInt(),
      country: json['country'] == null
          ? null
          : UserCountryModel.fromJson(json['country'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : UserSettingsModel.fromJson(
              json['settings'] as Map<String, dynamic>),
      preferences: (json['preferences'] as List<dynamic>?)
          ?.map((e) => UserPreferenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'photo': instance.photo,
      'organizationName': instance.organizationName,
      'isApproved': instance.isApproved,
      'isVerified': instance.isVerified,
      'jobTitle': instance.jobTitle,
      'phoneNumber': instance.phoneNumber,
      'language': instance.language,
      'status': instance.status,
      'authorId': instance.authorId,
      'country': instance.country,
      'settings': instance.settings,
      'preferences': instance.preferences,
    };

UserCountryModel _$UserCountryModelFromJson(Map<String, dynamic> json) =>
    UserCountryModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      name: json['name'] as String,
      national: json['national'] as String,
      isoCode: json['isoCode'] as String,
      phoneCode: json['phoneCode'] as String,
      regionId: (json['regionId'] as num).toInt(),
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      color: json['color'] as String,
    );

Map<String, dynamic> _$UserCountryModelToJson(UserCountryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'national': instance.national,
      'name': instance.name,
      'isoCode': instance.isoCode,
      'phoneCode': instance.phoneCode,
      'regionId': instance.regionId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'color': instance.color,
    };

UserPreferenceModel _$UserPreferenceModelFromJson(Map<String, dynamic> json) =>
    UserPreferenceModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$UserPreferenceModelToJson(
        UserPreferenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'description': instance.description,
      'icon': instance.icon,
    };

UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) =>
    UserSettingsModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
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

Map<String, dynamic> _$UserSettingsModelToJson(UserSettingsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
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
