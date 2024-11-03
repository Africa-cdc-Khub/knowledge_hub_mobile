// lib/ui/screens/language_selection/language_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:khub_mobile/providers/locale_provider.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/components.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';
import 'package:provider/provider.dart';

enum Language {
  english,
  spanish,
  french,
  swahili,
  arabic,
  portuguese,
}

class LanguageModel {
  final Language language;
  final String name;
  final String code;
  final String flag;

  LanguageModel({
    required this.language,
    required this.name,
    required this.code,
    required this.flag,
  });
}

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late LocaleProvider localeProvider;
  List<LanguageModel> languages = [];

  @override
  void initState() {
    super.initState();
    localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    languages = [
      LanguageModel(
          language: Language.english,
          name: 'English',
          code: 'en',
          flag: '🇬🇧'),
      LanguageModel(
          language: Language.spanish,
          name: 'Spanish',
          code: 'es',
          flag: '🇪🇸'),
      LanguageModel(
          language: Language.french, name: 'French', code: 'fr', flag: '🇫🇷'),
      LanguageModel(
          language: Language.swahili,
          name: 'Swahili',
          code: 'sw',
          flag: '🇰🇪'),
      LanguageModel(
          language: Language.arabic, name: 'Arabic', code: 'ar', flag: '🇸🇦'),
      LanguageModel(
          language: Language.portuguese,
          name: 'Portuguese',
          code: 'pt',
          flag: '🇵🇹'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: const Color.fromARGB(255, 239, 239, 239),
        elevation: 1,
        centerTitle: true,
        title: appBarText(context, context.localized.language),
      ),
      body: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) => Container(
          padding: const EdgeInsets.all(16),
          color: MainTheme.appColors.white900,
          child: ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) => ListTile(
              leading: Text(
                languages[index].flag,
                style: const TextStyle(fontSize: 16),
              ),
              title: Text(languages[index].name),
              trailing:
                  localeProvider.locale?.languageCode == languages[index].code
                      ? const Icon(Icons.check)
                      : null,
              onTap: () {
                localeProvider.setLocale(languages[index].code);
              },
            ),
          ),
        ),
      ),
    );
  }
}
