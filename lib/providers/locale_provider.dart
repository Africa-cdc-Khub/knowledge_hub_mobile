// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier with SafeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  Future<Locale?> getCachedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selected_language');
    _locale = (languageCode?.isEmpty ?? true)
        ? const Locale('en')
        : Locale(languageCode!);
    LOGGER.d('Current language: ${_locale?.languageCode}');
    safeNotifyListeners();
    return _locale;
  }

  Future<void> _cacheLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
  }

  void setLocale(String languageCode) async {
    if (!AppLocalizations.supportedLocales.contains(Locale(languageCode))) {
      return;
    }
    await _cacheLanguage(languageCode);
    _locale = Locale(languageCode);

    safeNotifyListeners();
  }
}
