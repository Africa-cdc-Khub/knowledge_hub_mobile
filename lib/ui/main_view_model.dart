import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/cache/utility_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/community_model.dart';
import 'package:khub_mobile/models/country_model.dart';
import 'package:khub_mobile/models/preference_model.dart';
import 'package:khub_mobile/models/resource_model.dart';
import 'package:khub_mobile/repository/notifications_repository.dart';
import 'package:khub_mobile/repository/utility_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class MainState {
  int _unreadNotifications = 0;
  List<PreferenceModel> _preferences = [];
  List<CountryModel> _countries = [];
  List<CommunityModel> _communities = [];
  List<ResourceTypeModel> _resourceTypes = [];
  List<ResourceCategoryModel> _resourceCategories = [];

  int get unreadNotifications => _unreadNotifications;
  List<PreferenceModel> get preferences => _preferences;
  List<CountryModel> get countries => _countries;
  List<CommunityModel> get communities => _communities;
  List<ResourceTypeModel> get resourceTypes => _resourceTypes;
  List<ResourceCategoryModel> get resourceCategories => _resourceCategories;
}

class MainViewModel extends ChangeNotifier with SafeNotifier {
  final UtilityRepository utilityRepository;
  final UtilityDatasource utilityDatasource;
  final NotificationRepository notificationRepository;

  MainState state = MainState();

  MainState get getState => state;

  MainViewModel(this.utilityRepository, this.utilityDatasource,
      this.notificationRepository);

  Future<int> getUnreadNotificationCount() async {
    final countState =
        await notificationRepository.getUnreadNotificationCount();
    if (countState is DataSuccess && countState.data != null) {
      state._unreadNotifications = countState.data!;
      safeNotifyListeners();
      return countState.data!;
    }
    return 0;
  }

  Future<List<ResourceTypeModel>> getResourceTypes() async {
    try {
      if (state._resourceTypes.isEmpty) {
        final list = await utilityDatasource.getResourceTypes();
        state._resourceTypes = list;
        safeNotifyListeners();
        return list;
      }

      return state._resourceTypes;
    } on Exception catch (err) {
      LOGGER.e(err);
      return [];
    }
  }

  Future<List<ResourceCategoryModel>> getResourceCategories() async {
    try {
      if (state._resourceCategories.isEmpty) {
        final list = await utilityDatasource.getResourceCategories();
        state._resourceCategories = list;
        safeNotifyListeners();
        return list;
      }

      return state._resourceCategories;
    } on Exception catch (err) {
      LOGGER.e(err);
      return [];
    }
  }

  Future<List<CommunityModel>> getCommunities() async {
    try {
      if (state._communities.isEmpty) {
        final list = await utilityDatasource.getCommunities();
        state._communities = list;
        safeNotifyListeners();
        return list;
      }

      return state._communities;
    } on Exception catch (err) {
      LOGGER.e(err);
      return [];
    }
  }

  Future<List<CountryModel>> getCountries() async {
    // LOGGER.d('Getting countries');
    try {
      if (state._countries.isEmpty) {
        final list = await utilityDatasource.getCountries();
        state._countries = list;
        LOGGER.d('Downloaded Countries: ${state._countries.length}');
        safeNotifyListeners();
        return list;
      } else {
        LOGGER.d('Returning cached countries: ${state._countries.length}');
        return state._countries;
      }
    } on Exception catch (err) {
      LOGGER.e(err);
      return [];
    }
  }

  Future<List<PreferenceModel>> getPreferences() async {
    try {
      if (state._preferences.isEmpty) {
        final list = await utilityDatasource.getPreferences();
        state._preferences = list;
        safeNotifyListeners();
        return list;
      }

      return state._preferences;
    } on Exception catch (err) {
      LOGGER.e(err);
      return [];
    }
  }

  Future<void> syncUtilities() async {
    if (utilityDatasource.isUtilitiesSynced()) {
      // await getJobs();
      // await getCommunities();
      // await getCountries();
      // await getPreferences();
      // await getFileTypes();
      // await getFileCategories();
      return;
    }

    // Countries
    final countryState = await utilityRepository.fetchCountries();
    if (countryState is DataSuccess && countryState.data != null) {
      if (countryState.data!.isNotEmpty) {
        await utilityDatasource.saveCountries(countryState.data!);
      }
    }

    // Jobs
    final jobState = await utilityRepository.fetchJobs();
    if (jobState is DataSuccess && jobState.data != null) {
      if (jobState.data!.isNotEmpty) {
        await utilityDatasource.saveJobs(jobState.data!);
      }
    }

    // Communities
    final communityState = await utilityRepository.fetchCommunities();
    if (communityState is DataSuccess && communityState.data != null) {
      if (communityState.data!.isNotEmpty) {
        await utilityDatasource.saveCommunities(communityState.data!);
      }
    }

    // Preferences
    final preferenceState = await utilityRepository.fetchPreferences();
    if (preferenceState is DataSuccess && preferenceState.data != null) {
      if (preferenceState.data!.isNotEmpty) {
        await utilityDatasource.savePreferences(preferenceState.data!);
      }
    }

    // Resource categories
    final resourceCategoryState =
        await utilityRepository.fetchResourceCategories();
    if (resourceCategoryState is DataSuccess &&
        resourceCategoryState.data != null) {
      if (resourceCategoryState.data!.isNotEmpty) {
        await utilityDatasource
            .saveResourceCategories(resourceCategoryState.data!);
      }
    }

    // Resource types
    final resourceTypeState = await utilityRepository.fetchResourceTypes();
    if (resourceTypeState is DataSuccess && resourceTypeState.data != null) {
      if (resourceTypeState.data!.isNotEmpty) {
        await utilityDatasource.saveResourceTypes(resourceTypeState.data!);
      }
    }

    await utilityDatasource.setUtilitiesSynced(true);
    getCommunities();
    getCountries();
    getPreferences();

    LOGGER.d("Utilities sync complete...");
  }
}
