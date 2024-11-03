import 'package:flutter/material.dart';
import 'package:khub_mobile/cache/utility_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/preference_model.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class PreferencesSearchState {
  List<PreferenceModel> _list = [];

  List<PreferenceModel> get list => _list;
}

class PreferencesSearchViewModel extends ChangeNotifier with SafeNotifier {
  final PreferencesSearchState _state = PreferencesSearchState();
  PreferencesSearchState get state => _state;

  final UtilityDatasource utilityDatasource;

  PreferencesSearchViewModel({required this.utilityDatasource});

  Future<void> fetchInitialPreferences() async {
    try {
      final result = await utilityDatasource.getPreferencesByLimit(50);
      _state._list = result;
      safeNotifyListeners();
    } catch (e) {
      LOGGER.e(e);
    }
  }

  Future<void> searchPreferences(String query) async {
    try {
      if (query.isEmpty) {
        fetchInitialPreferences();
        return;
      }

      final result = await utilityDatasource.searchPreferencesByName(query);
      _state._list = result;
      safeNotifyListeners();
    } catch (e) {
      LOGGER.e(e);
    }
  }
}
