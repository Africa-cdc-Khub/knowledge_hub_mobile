import 'dart:io';

import 'package:flutter/material.dart';
import 'package:khub_mobile/api/models/data_state.dart';
import 'package:khub_mobile/cache/utility_datasource.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/option_item_model.dart';
import 'package:khub_mobile/repository/auth_repository.dart';
import 'package:khub_mobile/repository/publication_repository.dart';
import 'package:khub_mobile/repository/theme_repository.dart';
import 'package:khub_mobile/ui/providers/safe_notifier.dart';

class PublicationRequest {
  File? cover;
  OptionItemModel? resourceType;
  OptionItemModel? resourceCategory;
  OptionItemModel? subTheme;
  OptionItemModel? theme;
  List<OptionItemModel> communities = [];
  String title = '';
  String? description;
  String author = '';
  int userId = -1;
  OptionItemModel? country;
  OptionItemModel? publicationCategory;
  String link = '';
}

class PublishState {
  bool _loading = false;
  final bool _isLoggedIn = false;
  List<OptionItemModel> _themes = [];
  List<OptionItemModel> _subThemes = [];
  PublicationRequest _publicationRequest = PublicationRequest();

  bool isSuccess = false;
  String errorMessage = '';
  dynamic response;

  bool get loading => _loading;
  bool get isLoggedIn => _isLoggedIn;
  List<OptionItemModel> get themeList => _themes;
  List<OptionItemModel> get subThemeList => _subThemes;
  PublicationRequest get publicationRequest => _publicationRequest;

  PublishState();
  PublishState.success(this.isSuccess, this.response);
  PublishState.error(this.isSuccess, this.errorMessage);
}

class PublishViewModel extends ChangeNotifier with SafeNotifier {
  PublishState state = PublishState();

  PublishState get getState => state;

  final AuthRepository authRepository;
  final UtilityDatasource utilityDatasource;
  final ThemeRepository themeRepository;
  final PublicationRepository publicationRepository;

  PublishViewModel({
    required this.publicationRepository,
    required this.authRepository,
    required this.utilityDatasource,
    required this.themeRepository,
  });

  Future<void> fetchThemes() async {
    state._loading = true;
    safeNotifyListeners();

    try {
      final result = await themeRepository.fetchThemes();

      if (result is DataSuccess) {
        final list = result.data!;
        state._themes = list
            .map(
                (item) => OptionItemModel(item.id.toString(), item.description))
            .toList();
      }

      if (result is DataError) {
        state.errorMessage = result.error ?? 'Error';
      }
    } on Exception catch (err) {
      LOGGER.e(err);
    } finally {
      state._loading = false;
      safeNotifyListeners();
    }
  }

  Future<void> fetchSubThemes({required int themeId}) async {
    state._loading = true;
    safeNotifyListeners();

    try {
      final result =
          await themeRepository.fetchSubThemesByTheme(themeId: themeId);

      if (result is DataSuccess) {
        final list = result.data!;
        state._subThemes = list
            .map(
                (item) => OptionItemModel(item.id.toString(), item.description))
            .toList();
      }

      if (result is DataError) {
        state.errorMessage = result.error ?? 'Error';
      }
    } on Exception catch (err) {
      LOGGER.e(err);
    } finally {
      state._loading = false;
      safeNotifyListeners();
    }
  }

  void resetRequest() {
    state._publicationRequest = PublicationRequest();
    notifyListeners();
  }

  void setRequest({
    File? cover,
    OptionItemModel? resourceType,
    OptionItemModel? resourceCategory,
    OptionItemModel? subTheme,
    OptionItemModel? theme,
    String? title,
    String? description,
    String? author,
    int? userId,
    OptionItemModel? country,
    OptionItemModel? publicationCategory,
    List<OptionItemModel>? communities,
    String? link,
  }) {
    if (title != null) {
      state._publicationRequest.title = title;
    }

    if (country != null) {
      state._publicationRequest.country = country;
    }

    if (theme != null) {
      state._publicationRequest.theme = theme;
    }

    if (subTheme != null) {
      state._publicationRequest.subTheme = subTheme;
    }

    if (cover != null) {
      state._publicationRequest.cover = cover;
    }

    if (resourceType != null) {
      state._publicationRequest.resourceType = resourceType;
    }

    if (resourceCategory != null) {
      state._publicationRequest.resourceCategory = resourceCategory;
    }

    if (description != null) {
      state._publicationRequest.description = description;
    }

    if (author != null) {
      state._publicationRequest.author = author;
    }

    if (userId != null) {
      state._publicationRequest.userId = userId;
    }

    if (publicationCategory != null) {
      state._publicationRequest.publicationCategory = publicationCategory;
    }

    if (link != null) {
      state._publicationRequest.link = link;
    }

    if (communities != null) {
      state._publicationRequest.communities = communities;
    }

    notifyListeners();
  }

  Future<PublishState> submitRequest() async {
    final model = state._publicationRequest;

    // LOGGER.d({
    //   'resourceTyope': int.parse(model.resourceType!.id),
    //   'subTheme': int.parse(model.subTheme!.id),
    //   'title': model.title,
    //   'cover': model.cover,
    //   'description': model.description,
    //   'author': model.author,
    //   'resourceCategory': int.parse(model.resourceCategory!.id),
    //   'link': model.link,
    //   'communities': model.communities
    //       .map((item) => int.parse(item.id))
    //       .toList()
    //       .toString()
    // });

    final result = await publicationRepository.createPublication(
        cover: model.cover,
        resourceType: int.parse(model.resourceType!.id),
        subTheme: int.parse(model.subTheme!.id),
        title: model.title,
        description: model.description!,
        author: model.author,
        resourceCategory: int.parse(model.resourceCategory!.id),
        link: model.link,
        communities: model.communities
            .map((item) => int.parse(item.id))
            .toList()
            .toString());

    if (result is DataSuccess) {
      return PublishState.success(true, result.data);
    }

    if (result is DataError) {
      return PublishState.error(false, result.error ?? '');
    }

    return PublishState();
  }
}
