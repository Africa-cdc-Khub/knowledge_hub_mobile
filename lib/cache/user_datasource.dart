import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

import 'db/app_database.dart';
import 'db/cache_database.dart';

abstract class UserDatasource {
  Future<void> saveUsers(List<UserModel> entities);
  Future<void> saveUser(UserModel entity);

  Future<void> saveUserCountries(List<UserCountryModel> entities);
  Future<void> saveUserCountry(UserCountryModel entity);

  Future<void> saveUserPreferences(List<UserPreferenceModel> entities);
  Future<void> saveUserPreference(UserPreferenceModel entity);

  Future<List<UserModel>> getUsers();
  Future<List<UserCountryModel>> getUserCountries();
  Future<List<UserPreferenceModel>> getUserPreferences();

  Future<List<UserSettingsModel>> getUserSettings();
  Future<void> saveUserSettings(List<UserSettingsModel> entities);
  Future<void> saveUserSetting(UserSettingsModel entity);

  Future<void> deleteAllUsers();
  Future<void> deleteUser(int userId);
  Future<void> deleteAllUserCountries();
  Future<void> deleteUserCountry(int userCountryId);
}

class UserDatasourceImpl implements UserDatasource {
  @override
  Future<List<UserCountryModel>> getUserCountries() async {
    try {
      final db = await CacheDatabase().database;
      final list = await db.query(AppDatabase.userCountryTable);
      List<UserCountryModel> modelList = [];

      for (var item in list) {
        modelList.add(UserCountryModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get user countries');
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final db = await CacheDatabase().database;
      final list = await db.query(AppDatabase.userTable);
      List<UserModel> modelList = [];

      for (var item in list) {
        modelList.add(UserModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get users');
    }
  }

  @override
  Future<void> saveUsers(List<UserModel> entities) async {
    try {
      final db = await CacheDatabase().database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.userTable,
          entity.toDbJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save users');
    }
  }

  @override
  Future<void> saveUserCountries(List<UserCountryModel> entities) async {
    try {
      final db = await CacheDatabase().database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.userCountryTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save user countries');
    }
  }

  @override
  Future<void> saveUser(UserModel entity) async {
    try {
      final db = await CacheDatabase().database;

      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.userTable,
          entity.toDbJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save user');
    }
  }

  @override
  Future<void> saveUserCountry(UserCountryModel entity) async {
    try {
      final db = await CacheDatabase().database;

      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.userCountryTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      throw Exception('Failed to save user country');
    }
  }

  @override
  Future<void> deleteAllUsers() async {
    try {
      final db = await CacheDatabase().database;
      await db.delete(AppDatabase.userTable);
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to delete all users');
    }
  }

  @override
  Future<void> deleteUser(int userId) async {
    try {
      final db = await CacheDatabase().database;
      await db.delete(
        AppDatabase.userTable,
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to delete user');
    }
  }

  @override
  Future<void> deleteAllUserCountries() async {
    try {
      final db = await CacheDatabase().database;
      await db.delete(AppDatabase.userCountryTable);
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to delete all user countries');
    }
  }

  @override
  Future<void> deleteUserCountry(int userCountryId) async {
    try {
      final db = await CacheDatabase().database;
      await db.delete(
        AppDatabase.userCountryTable,
        where: 'id = ?',
        whereArgs: [userCountryId],
      );
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to delete user country');
    }
  }

  @override
  Future<List<UserSettingsModel>> getUserSettings() async {
    try {
      final db = await CacheDatabase().database;
      final list = await db.query(AppDatabase.userSettingsTable);
      List<UserSettingsModel> modelList = [];

      for (var item in list) {
        modelList.add(UserSettingsModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to get user settings');
    }
  }

  @override
  Future<void> saveUserSetting(UserSettingsModel entity) async {
    try {
      final db = await CacheDatabase().database;

      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.userSettingsTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save user setting');
    }
  }

  @override
  Future<void> saveUserSettings(List<UserSettingsModel> entities) async {
    try {
      final db = await CacheDatabase().database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.userSettingsTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save user settings');
    }
  }

  @override
  Future<void> saveUserPreference(UserPreferenceModel entity) async {
    try {
      final db = await CacheDatabase().database;
      await db.transaction((txn) async {
        await txn.insert(
          AppDatabase.userPreferenceTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save user preference');
    }
  }

  @override
  Future<void> saveUserPreferences(List<UserPreferenceModel> entities) async {
    try {
      final db = await CacheDatabase().database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.userPreferenceTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to save user preferences');
    }
  }

  @override
  Future<List<UserPreferenceModel>> getUserPreferences() async {
    try {
      final db = await CacheDatabase().database;
      final list = await db.query(AppDatabase.userPreferenceTable);
      List<UserPreferenceModel> modelList = [];

      for (var item in list) {
        modelList.add(UserPreferenceModel.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to get user preferences');
    }
  }
}
