
import 'package:khub_mobile/cache/db/cache_database.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/theme_model.dart';
import 'package:sqflite/sqflite.dart';

import 'db/app_database.dart';

abstract class ThemeDatasource {
  Future<void> saveThemes(List<ThemeModel> entities);
  Future<List<ThemeModel>> getThemes();
}

class ThemeDataSourceImpl implements ThemeDatasource {
  @override
  Future<List<ThemeModel>> getThemes() async {
    try {
      final db = await CacheDatabase().database;
      final list = await db.query(AppDatabase.themeTable);
      List<ThemeModel> modelList = [];

      for (var item in list) {
        modelList.add(ThemeModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to get themes');
    }
  }

  @override
  Future<void> saveThemes(List<ThemeModel> entities) async {
    try {
      final db = await CacheDatabase().database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.themeTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save theme');
    }
  }
  
}