import 'package:khub_mobile/cache/db/app_database.dart';
import 'package:khub_mobile/cache/models/publication_entity.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:sqflite/sqflite.dart';

abstract class PublicationDataSource {
  Future<void> savePublications(List<PublicationEntity> entities);
  Future<void> savePublicationsByType(
      List<PublicationEntity> entities, int type);
  Future<List<PublicationEntity>> getPublications();
  Future<List<PublicationEntity>> getPublicationsByType(int type);
  Future<void> deletePublications(int type);
}

class PublicationDataSourceImpl implements PublicationDataSource {
  Database? _database;

  PublicationDataSourceImpl();

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
  @override
  Future<void> savePublications(List<PublicationEntity> entities) async {
    try {
      final db = await database;

      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.publicationTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to save publications');
    }
  }

  @override
  Future<void> savePublicationsByType(
      List<PublicationEntity> entities, int type) async {}

  @override
  Future<List<PublicationEntity>> getPublications() async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.publicationTable);
      List<PublicationEntity> modelList = [];

      for (var item in list) {
        modelList.add(PublicationEntity.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      throw Exception('Failed to get publications');
    }
  }

  @override
  Future<List<PublicationEntity>> getPublicationsByType(int type) async {
    try {
      final db = await database;
      final list = await db.query(AppDatabase.publicationTable,
          where: 'type = ?', whereArgs: [type]);
      if (list.isEmpty) {
        return [];
      }
      List<PublicationEntity> modelList = [];

      for (var item in list) {
        modelList.add(PublicationEntity.fromJson(item));
      }

      return Future.value(modelList);
    } catch (e) {
      LOGGER.e(e);
      throw Exception('Failed to get publications');
    }
  }

  @override
  Future<void> deletePublications(int type) async {
    try {
      final db = await database;
      await db.delete(AppDatabase.publicationTable,
          where: 'type = ?', whereArgs: [type]);
    } catch (e) {
      throw Exception('Failed to delete publications');
    }
  }
}
