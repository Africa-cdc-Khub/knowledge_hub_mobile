import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/user/user_api_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int id;
  String name;
  String firstName;
  String lastName;
  String email;
  String photo;
  String organizationName;
  int isApproved;
  int isVerified;
  String jobTitle;
  String phoneNumber;
  String language;
  int status;
  int authorId;
  UserCountryModel? country;
  UserSettingsModel? settings;
  List<UserPreferenceModel>? preferences;

  UserModel(
      {required this.id,
      required this.name,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.photo,
      required this.organizationName,
      required this.isApproved,
      required this.isVerified,
      required this.jobTitle,
      required this.phoneNumber,
      required this.language,
      required this.status,
      required this.authorId,
      required this.country,
      required this.settings,
      required this.preferences});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  Map<String, dynamic> toDbJson() {
    return {
      'id': id,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'photo': photo,
      'organizationName': organizationName,
      'isApproved': isApproved,
      'isVerified': isVerified,
      'jobTitle': jobTitle,
      'phoneNumber': phoneNumber,
      'language': language,
      'status': status,
      'authorId': authorId
    };
  }

  factory UserModel.fromApiModel(UserApiModel model) {
    return UserModel(
        id: model.id ?? -1,
        name: model.name ?? '',
        firstName: model.first_name ?? '',
        lastName: model.last_name ?? '',
        email: model.email ?? '',
        photo: model.photo ?? '',
        organizationName: model.organization_name ?? '',
        isApproved: model.is_approved ?? -1,
        isVerified: model.is_verified ?? -1,
        jobTitle: model.job_title ?? '',
        phoneNumber: model.phone_number ?? '',
        language: model.langauge ?? '',
        status: model.status ?? -1,
        authorId: model.author_id ?? -1,
        country: model.country != null
            ? UserCountryModel.fromApiModel(model.country!, model.id)
            : null,
        settings: model.settings != null
            ? UserSettingsModel.fromApiModel(model.settings!, model.id)
            : null,
        preferences: model.preferences
            ?.map((e) => UserPreferenceModel.fromApiModel(e, model.id))
            .toList());
  }
}

@JsonSerializable()
class UserCountryModel {
  int id;
  int userId;
  String national;
  String name;
  String isoCode;
  String phoneCode;
  int regionId;
  double longitude;
  double latitude;
  String color;

  UserCountryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.national,
    required this.isoCode,
    required this.phoneCode,
    required this.regionId,
    required this.longitude,
    required this.latitude,
    required this.color,
  });

  factory UserCountryModel.fromJson(Map<String, dynamic> json) =>
      _$UserCountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserCountryModelToJson(this);

  factory UserCountryModel.fromApiModel(
      UserCountryApiModel model, int? userId) {
    return UserCountryModel(
        id: model.id ?? -1,
        userId: userId ?? -1,
        name: model.name ?? '',
        national: model.national ?? '',
        isoCode: model.iso_code ?? '',
        phoneCode: model.phonecode ?? '',
        regionId: model.region_id ?? -1,
        longitude: model.longitude ?? 0.0,
        latitude: model.latitude ?? 0.0,
        color: model.color ?? '');
  }
}

@JsonSerializable()
class UserPreferenceModel {
  int id;
  int userId;
  String description;
  String icon;

  UserPreferenceModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.icon,
  });

  factory UserPreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferenceModelToJson(this);

  factory UserPreferenceModel.fromApiModel(
      UserPreferenceApiModel model, int? userId) {
    return UserPreferenceModel(
      id: model.id ?? -1,
      userId: userId ?? -1,
      description: model.description ?? '',
      icon: model.icon ?? '',
    );
  }
}

@JsonSerializable()
class UserSettingsModel {
  int id;
  int userId;
  String title;
  String siteName;
  String seoKeywords;
  String siteDescription;
  String address;
  String email;
  String phone;
  String language;
  String timezone;
  String primaryColor;
  String secondaryColor;
  String logo;
  String favicon;
  String iconFontColor;
  String primaryTextColor;
  String linksActiveColor;
  String spotlightBanner;
  String bannerText;
  String slogan;

  UserSettingsModel(
      {required this.id,
      required this.userId,
      required this.title,
      required this.siteName,
      required this.seoKeywords,
      required this.siteDescription,
      required this.address,
      required this.email,
      required this.phone,
      required this.language,
      required this.timezone,
      required this.primaryColor,
      required this.secondaryColor,
      required this.logo,
      required this.favicon,
      required this.iconFontColor,
      required this.primaryTextColor,
      required this.linksActiveColor,
      required this.spotlightBanner,
      required this.bannerText,
      required this.slogan});

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsModelToJson(this);

  factory UserSettingsModel.fromApiModel(
      UserSettingsApiModel model, int? userId) {
    return UserSettingsModel(
      id: model.id ?? -1,
      userId: userId ?? -1,
      title: model.title ?? '',
      siteName: model.site_name ?? '',
      seoKeywords: model.seo_keywords ?? '',
      siteDescription: model.site_description ?? '',
      address: model.address ?? '',
      email: model.email ?? '',
      phone: model.phone ?? '',
      language: model.language ?? '',
      timezone: model.timezone ?? '',
      primaryColor: model.primary_color ?? '',
      secondaryColor: model.secondary_color ?? '',
      logo: model.logo ?? '',
      favicon: model.favicon ?? '',
      iconFontColor: model.icon_font_color ?? '',
      primaryTextColor: model.primary_text_color ?? '',
      linksActiveColor: model.links_active_color ?? '',
      spotlightBanner: model.spotlight_banner ?? '',
      bannerText: model.banner_text ?? '',
      slogan: model.slogan ?? '',
    );
  }
}
