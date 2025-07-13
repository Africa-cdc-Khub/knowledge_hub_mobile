import 'package:json_annotation/json_annotation.dart';
import 'package:khub_mobile/api/models/user/user_api_model.dart';

part 'settings_model.g.dart';

@JsonSerializable()
class SettingsModel {
  int id;
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
  String contentDisclaimer;

  SettingsModel(
      {required this.id,
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
      required this.slogan,
      required this.contentDisclaimer});

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);

  factory SettingsModel.fromApiModel(UserSettingsApiModel model) {
    return SettingsModel(
        id: model.id ?? -1,
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
        contentDisclaimer: model.content_disclaimer ?? '');
  }
}
