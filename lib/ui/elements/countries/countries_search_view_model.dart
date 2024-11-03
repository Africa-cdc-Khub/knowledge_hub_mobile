import 'package:flutter/material.dart';
import 'package:khub_mobile/cache/utility_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/country_model.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class CountriesState {
  List<CountryModel> _list = [];

  List<CountryModel> get list => _list;
}

class CountriesSearchViewModel extends ChangeNotifier with SafeNotifier {
  final CountriesState _state = CountriesState();
  CountriesState get state => _state;

  final UtilityDatasource utilityDatasource;

  CountriesSearchViewModel({required this.utilityDatasource});

  Future<void> fetchInitialCountries() async {
    try {
      final result = await utilityDatasource.getCountriesByLimit(25);
      _state._list = result;
      safeNotifyListeners();
    } catch (e) {
      LOGGER.e(e);
    }
  }

  Future<void> searchCountries(String query) async {
    try {
      if (query.isEmpty) {
        fetchInitialCountries();
        return;
      }

      final result = await utilityDatasource.searchCountriesByName(query);
      _state._list = result;
      safeNotifyListeners();
    } catch (e) {
      LOGGER.e(e);
    }
  }
}
