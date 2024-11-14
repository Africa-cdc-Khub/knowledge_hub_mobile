import 'package:khub_mobile/cache/models/community_entity.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/community_model.dart';
import 'package:khub_mobile/models/country_model.dart';
import 'package:khub_mobile/models/file_category_model.dart';
import 'package:khub_mobile/models/file_type_model.dart';
import 'package:khub_mobile/models/job_model.dart';
import 'package:khub_mobile/models/preference_model.dart';
import 'package:khub_mobile/models/resource_model.dart';
import 'package:sqflite/sqflite.dart';

import 'db/app_database.dart';
import 'preferences_datasource.dart';

abstract class UtilityDatasource {
  Future<void> saveFileType(FileTypeModel entity);
  Future<void> saveFileTypes(List<FileTypeModel> entities);
  Future<List<FileTypeModel>> getFileTypes();

  Future<void> saveFileCategory(FileCategoryModel entity);
  Future<void> saveFileCategories(List<FileCategoryModel> entities);
  Future<List<FileCategoryModel>> getCategories();

  Future<void> saveCommunity(CommunityModel entity);
  Future<void> saveCommunities(List<CommunityModel> entities);
  Future<List<CommunityModel>> getCommunities();

  Future<void> savePreference(PreferenceModel entity);
  Future<void> savePreferences(List<PreferenceModel> entities);
  Future<List<PreferenceModel>> getPreferences();
  Future<List<PreferenceModel>> searchPreferencesByName(String query);
  Future<List<PreferenceModel>> getPreferencesByLimit(int limit);

  Future<void> saveJob(JobModel entity);
  Future<void> saveJobs(List<JobModel> entities);
  Future<List<JobModel>> getJobs();
  Future<List<JobModel>> searchJobsByName(String query);
  Future<List<JobModel>> getJobsByLimit(int limit);

  Future<void> saveCountry(CountryModel entity);
  Future<void> saveCountries(List<CountryModel> entities);
  Future<List<CountryModel>> getCountries();
  Future<List<CountryModel>> searchCountriesByName(String query);
  Future<List<CountryModel>> getCountriesByLimit(int limit);

  Future<void> saveResourceCategory(ResourceCategoryModel entity);
  Future<void> saveResourceCategories(List<ResourceCategoryModel> entities);
  Future<List<ResourceCategoryModel>> getResourceCategories();

  Future<void> saveResourceType(ResourceTypeModel entity);
  Future<void> saveResourceTypes(List<ResourceTypeModel> entities);
  Future<List<ResourceTypeModel>> getResourceTypes();

  Future<void> setUtilitiesSynced(bool value);
  bool isUtilitiesSynced();
}

class UtilityDatasourceImpl implements UtilityDatasource {
  // Todo Make this a singleton
  static Database? _database;

  final PreferencesDatasource preferences;

  UtilityDatasourceImpl({required this.preferences});

  Future<Database> get database async {
    try {
      _database ??= await AppDatabase().initDb();
    } on Exception catch (e) {
      _database = null;
      LOGGER.e(e);
    }
    return _database!;
  }

  @override
  Future<List<FileTypeModel>> getFileTypes() async {
    try {
      final db = await database;
      // final list = await db.rawQuery('SELECT * FROM ${AppDatabase.fileTypeTable}');
      final list = await db.query(AppDatabase.fileTypeTable);
      List<FileTypeModel> modelList = [];

      for (var item in list) {
        modelList.add(FileTypeModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get file types');
    }
  }

  @override
  Future<List<FileCategoryModel>> getCategories() async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.fileCategoryTable);
      List<FileCategoryModel> modelList = [];

      for (var item in list) {
        modelList.add(FileCategoryModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get file categories');
    }
  }

  @override
  Future<List<CommunityModel>> getCommunities() async {
    try {
      final db = await database;
      // final list = await db.rawQuery('SELECT * FROM ${AppDatabase.communityTable}');
      final list = await db.query(AppDatabase.communityTable);
      List<CommunityEntity> modelList = [];

      for (var item in list) {
        modelList.add(CommunityEntity.fromJson(item));
      }

      return Future.value(
          modelList.map((e) => CommunityModel.fromDbEntity(e)).toList());
    } catch (e) {
      throw Exception('Failed to get communities');
    }
  }

  @override
  Future<List<JobModel>> getJobs() async {
    try {
      final db = await database;
      // final list = await db.rawQuery('SELECT * FROM ${AppDatabase.jobTable}');
      final list = await db.query(AppDatabase.jobTable);
      List<JobModel> modelList = [];

      for (var item in list) {
        modelList.add(JobModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get jobs');
    }
  }

  @override
  Future<List<PreferenceModel>> getPreferences() async {
    try {
      final db = await database;
      // final list = await db.rawQuery('SELECT * FROM ${AppDatabase.preferenceTable}');
      final list = await db.query(AppDatabase.preferenceTable);
      List<PreferenceModel> modelList = [];

      for (var item in list) {
        modelList.add(PreferenceModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get preferences');
    }
  }

  @override
  Future<void> saveFileType(FileTypeModel entity) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await db.insert(
          AppDatabase.fileTypeTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save premise type');
    }
  }

  @override
  Future<void> saveCommunity(CommunityModel entity) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.communityTable,
          entity.toDbJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save community');
    }
  }

  @override
  Future<void> saveFileCategory(FileCategoryModel entity) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.fileCategoryTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save file category');
    }
  }

  @override
  Future<void> saveJob(JobModel entity) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.jobTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save job');
    }
  }

  @override
  Future<void> savePreference(PreferenceModel entity) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.preferenceTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save preference');
    }
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.countryTable);
      List<CountryModel> modelList = [];

      for (var item in list) {
        modelList.add(CountryModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get countries');
    }
  }

  @override
  Future<void> saveCountry(CountryModel entity) async {
    try {
      final db = await database;

      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.countryTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save country');
    }
  }

  @override
  Future<void> saveFileTypes(List<FileTypeModel> entities) async {
    try {
      final db = await database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.fileTypeTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save countries');
    }
  }

  @override
  Future<void> saveCommunities(List<CommunityModel> entities) async {
    try {
      final db = await database;
      var batch = db.batch();

      for (var entity in entities) {
        final dbEntity = CommunityEntity.fromModel(entity);
        await db.insert(
          AppDatabase.communityTable,
          dbEntity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save communities');
    }
  }

  @override
  Future<void> saveCountries(List<CountryModel> entities) async {
    try {
      final db = await database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.countryTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save countries');
    }
  }

  @override
  Future<void> saveFileCategories(List<FileCategoryModel> entities) async {
    try {
      final db = await database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.fileCategoryTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save file categories');
    }
  }

  @override
  Future<void> saveJobs(List<JobModel> entities) async {
    try {
      final db = await database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.jobTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save jobs');
    }
  }

  @override
  Future<void> savePreferences(List<PreferenceModel> entities) async {
    try {
      final db = await database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.preferenceTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save preferences');
    }
  }

  @override
  bool isUtilitiesSynced() {
    return preferences.getBoolean(PreferencesDatasource.utilitiesSyncedKey);
  }

  @override
  Future<void> setUtilitiesSynced(bool value) {
    return preferences.saveBoolean(
        PreferencesDatasource.utilitiesSyncedKey, value);
  }

  @override
  Future<List<ResourceCategoryModel>> getResourceCategories() async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.resourceCategoryTable);
      List<ResourceCategoryModel> modelList = [];

      for (var item in list) {
        modelList.add(ResourceCategoryModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get resource categories');
    }
  }

  @override
  Future<List<ResourceTypeModel>> getResourceTypes() async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.resourceTypeTable);
      List<ResourceTypeModel> modelList = [];

      for (var item in list) {
        modelList.add(ResourceTypeModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get resource types');
    }
  }

  @override
  Future<void> saveResourceCategories(
      List<ResourceCategoryModel> entities) async {
    try {
      final db = await database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.resourceCategoryTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save resource categories');
    }
  }

  @override
  Future<void> saveResourceCategory(ResourceCategoryModel entity) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.resourceCategoryTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save resource category');
    }
  }

  @override
  Future<void> saveResourceType(ResourceTypeModel entity) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.resourceTypeTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save resource type');
    }
  }

  @override
  Future<void> saveResourceTypes(List<ResourceTypeModel> entities) async {
    try {
      final db = await database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.resourceTypeTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save resource types');
    }
  }

  @override
  Future<List<JobModel>> searchJobsByName(String query) async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.jobTable,
          where: 'name LIKE ?',
          whereArgs: ['%$query%'],
          limit: 50,
          orderBy: 'name ASC');

      return list.map((item) => JobModel.fromJson(item)).toList();
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to search jobs');
    }
  }

  @override
  Future<List<JobModel>> getJobsByLimit(int limit) async {
    try {
      final db = await database;
      final list = await db.query(
        AppDatabase.jobTable,
        // orderBy: 'id DESC',
        limit: limit,
      );

      return list.map((item) => JobModel.fromJson(item)).toList();
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to get jobs with limit');
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByLimit(int limit) async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.countryTable, limit: limit);
      return list.map((item) => CountryModel.fromJson(item)).toList();
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to get countries with limit');
    }
  }

  @override
  Future<List<PreferenceModel>> getPreferencesByLimit(int limit) async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.preferenceTable, limit: limit);
      return list.map((item) => PreferenceModel.fromJson(item)).toList();
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to get preferences with limit');
    }
  }

  @override
  Future<List<CountryModel>> searchCountriesByName(String query) async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.countryTable,
          where: 'name LIKE ?',
          whereArgs: ['%$query%'],
          limit: 50,
          orderBy: 'name ASC');
      return list.map((item) => CountryModel.fromJson(item)).toList();
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to search countries');
    }
  }

  @override
  Future<List<PreferenceModel>> searchPreferencesByName(String query) async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.preferenceTable,
          where: 'name LIKE ?',
          whereArgs: ['%$query%'],
          limit: 50,
          orderBy: 'name ASC');
      return list.map((item) => PreferenceModel.fromJson(item)).toList();
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to search preferences');
    }
  }
}
