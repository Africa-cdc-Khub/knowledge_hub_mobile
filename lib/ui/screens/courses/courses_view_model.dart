import 'package:flutter/material.dart';
import 'package:khub_mobile/api/config/env_config.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/course_model.dart';
import 'package:khub_mobile/repository/courses_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class CoursesState {
  bool _loading = false;
  String _errorMessage = '';
  List<CourseModel> _courses = [];
  int _currentPage = EnvConfig.startPage;
  int _totalPages = 1;
  bool _isEndOfPage = false;
  bool _isRefreshing = false;

  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  List<CourseModel> get courses => _courses;
  bool get isRefreshing => _isRefreshing;
}

class CoursesViewModel extends ChangeNotifier with SafeNotifier {
  CoursesState state = CoursesState();
  CoursesState get getState => state;

  late final CoursesRepository coursesRepository;

  CoursesViewModel(this.coursesRepository);

  Future<void> fetchCourses({int page = EnvConfig.startPage}) async {
    state._loading = true;
    state._courses = []; // reset
    state._currentPage = EnvConfig.startPage; // reset
    state._isEndOfPage = false; // reset
    safeNotifyListeners();

    try {
      final result = await coursesRepository.fetchCourses(page: page);

      if (result is DataSuccess) {
        state._isRefreshing = false;
        state._totalPages = result.data?.total ?? 1;
        state._courses.addAll(result.data?.data
                ?.map((item) => CourseModel.fromApiModel(item))
                .toList() ??
            []);
        if (result.data != null &&
            result.data!.data != null &&
            result.data!.data!.isEmpty) {
          state._isEndOfPage = true;
        }
      }

      if (result is DataError) {
        state._isRefreshing = false;
        state._errorMessage = result.error ?? 'Error';
      }
    } on Exception catch (err) {
      LOGGER.e(err);
    } finally {
      state._loading = false;
      safeNotifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (state._currentPage < state._totalPages && !state._isEndOfPage) {
      try {
        final result = await coursesRepository.fetchCourses(
          page: ++state._currentPage,
        );

        if (result is DataSuccess) {
          state._totalPages = result.data?.total ?? 1;
          state._courses.addAll(result.data?.data
                  ?.map((item) => CourseModel.fromApiModel(item))
                  .toList() ??
              []);
          if (result.data != null &&
              result.data!.data != null &&
              result.data!.data!.isEmpty) {
            state._isEndOfPage = true;
          }
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
}
