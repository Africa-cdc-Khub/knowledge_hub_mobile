import 'package:flutter/material.dart';
import 'package:khub_mobile/api/config/config.dart';
import 'package:khub_mobile/cache/preferences_datasource.dart';
import 'package:khub_mobile/cache/utility_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class KnowledgeHubModel {
  int id;
  String name;
  String baseUrl;
  bool isActive;

  KnowledgeHubModel(
      {required this.id,
      required this.name,
      required this.baseUrl,
      required this.isActive});
}

class KnowledgeHubState {
  List<KnowledgeHubModel> _knowledgeHubs = [];
  bool _isLoading = false;
  List<KnowledgeHubModel> get knowledgeHubs => _knowledgeHubs;
  bool get isLoading => _isLoading;
}

class KnowledgeHubViewModel extends ChangeNotifier with SafeNotifier {
  final UtilityDatasource utilityDatasource;
  final PreferencesDatasource preferencesDatasource;
  final AuthRepository authRepository;

  KnowledgeHubState state = KnowledgeHubState();
  KnowledgeHubState get getState => state;

  KnowledgeHubViewModel(
      {required this.utilityDatasource,
      required this.preferencesDatasource,
      required this.authRepository});

  Future<List<KnowledgeHubModel>> fetchKnowledgeHubs() async {
    state._isLoading = true;
    safeNotifyListeners();

    try {
      if (state._knowledgeHubs.isEmpty) {
        final list = await utilityDatasource.getCountries();
        final filtered = list
            .where((element) =>
                element.isAppSupported == 1 && element.baseUrl.isNotEmpty)
            .map((e) => KnowledgeHubModel(
                id: e.id, name: e.name, baseUrl: e.baseUrl, isActive: false))
            .toList();

        // Add Africa CDC hub at the beginning of the list
        filtered.insert(
            0,
            KnowledgeHubModel(
                id: 10000,
                name: 'Africa CDC',
                baseUrl: Config().baseUrl,
                isActive: true));

        final savedActiveHubId = preferencesDatasource
            .getInt(PreferencesDatasource.activeKnowledgeHubKey);

        // Update the active status based on the saved preference
        if (savedActiveHubId != -1) {
          for (var hub in filtered) {
            hub.isActive = hub.id == savedActiveHubId;
          }
        }

        state._knowledgeHubs = filtered;
        return filtered;
      } else {
        return state._knowledgeHubs;
      }
    } on Exception catch (err) {
      LOGGER.e(err);
      return [];
    } finally {
      state._isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> setKnowledgeHub(KnowledgeHubModel knowledgeHub) async {
    try {
      // Save to cache
      await preferencesDatasource.saveString(
          PreferencesDatasource.baseUrlKey, knowledgeHub.baseUrl);
      await preferencesDatasource.saveInt(
          PreferencesDatasource.activeKnowledgeHubKey, knowledgeHub.id);

      // Log user out
      await authRepository.logout();

      return Future.value(true);
    } catch (err) {
      LOGGER.e(err);
      return Future.value(true);
    }
  }
}
