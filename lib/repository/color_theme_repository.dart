import 'dart:ui';

import 'package:khub_mobile/cache/preferences_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/utils/helpers.dart';

abstract class ColorThemeRepository {
  Future<void> saveThemeColors(String primary, String secondary);
  Future<Color?> loadPrimaryColor();
  Future<Color?> loadSecondaryColor();
}

class ColorThemeRepositoryImpl extends ColorThemeRepository {
  final PreferencesDatasource preferences;

  ColorThemeRepositoryImpl({required this.preferences});

  @override
  Future<Color?> loadPrimaryColor() async {
    final colorString =
        preferences.getString(PreferencesDatasource.primaryColorKey);
    if (colorString.isNotEmpty) {
      return Helpers.hexToColor(colorString);
    }
    return null;
  }

  @override
  Future<Color?> loadSecondaryColor() async {
    final colorString =
        preferences.getString(PreferencesDatasource.secondaryColorKey);
    if (colorString.isNotEmpty) {
      return Helpers.hexToColor(colorString);
    }
    return null;
  }

  @override
  Future<void> saveThemeColors(String primary, String secondary) async {
    LOGGER.d('Saving theme colors: $primary, $secondary');
    await preferences.saveString(
        PreferencesDatasource.primaryColorKey, primary);
    await preferences.saveString(
        PreferencesDatasource.secondaryColorKey, secondary);
  }
}
