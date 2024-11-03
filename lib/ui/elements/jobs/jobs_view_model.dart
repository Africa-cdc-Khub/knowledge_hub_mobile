import 'package:flutter/material.dart';
import 'package:khub_mobile/cache/utility_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/job_model.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class JobsState {
  List<JobModel> _list = [];

  List<JobModel> get list => _list;
}

class JobsViewModel extends ChangeNotifier with SafeNotifier {
  final JobsState _state = JobsState();
  JobsState get state => _state;

  final UtilityDatasource utilityDatasource;

  JobsViewModel({required this.utilityDatasource});

  Future<void> fetchInitialJobs() async {
    try {
      final result = await utilityDatasource.getJobsByLimit(20);
      _state._list = result;
      safeNotifyListeners();
    } catch (e) {
      LOGGER.e(e);
    }
  }

  Future<void> searchJobs(String query) async {
    try {
      if (query.isEmpty) {
        fetchInitialJobs();
        return;
      }

      final result = await utilityDatasource.searchJobsByName(query);
      _state._list = result;
      safeNotifyListeners();
    } catch (e) {
      LOGGER.e(e);
    }
  }
}
