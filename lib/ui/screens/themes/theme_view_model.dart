import 'package:flutter/cupertino.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/sub_theme_model.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:khub_mobile/repository/theme_repository.dart';
import 'package:khub_mobile/utils/helpers.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class ThemesState {
  bool _loading = false;
  String _errorMessage = '';
  final int _currentPage = 1;
  final int _totalPages = 1;
  List<ThemeModel> _themes = [];
  List<ThemeModel> _actionThemes = [];
  final List<SubThemeModel> _subThemes = [];

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  List<ThemeModel> get themeList => _themes;
  List<ThemeModel> get actionThemeList => _actionThemes;
  List<SubThemeModel> get subThemeList => _subThemes;
}

class ThemeViewModel extends ChangeNotifier with SafeNotifier {
  late final ThemeRepository themeRepository;
  ThemesState state = ThemesState();
  ThemesState get getState => state;

  ThemeViewModel(this.themeRepository);

  Future<void> fetchThemes() async {
    state._loading = true;
    safeNotifyListeners();

    try {
      final result = await themeRepository.fetchThemes();

      if (result is DataSuccess) {
        final list = result.data!;
        state._themes = list;
        final actionThemes = Helpers.pickNItems(list, 3);
        actionThemes.add(ThemeModel(
            id: 100000, description: '', icon: 'fa-users', displayIndex: 1));
        state._actionThemes = actionThemes;
      }

      if (result is DataError) {
        state._errorMessage = result.error ?? 'Error';
      }
    } on Exception catch (err) {
      LOGGER.e(err);
    } finally {
      state._loading = false;
      safeNotifyListeners();
    }
  }
}
