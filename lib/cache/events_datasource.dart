import 'package:khub_mobile/cache/db/app_database.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:khub_mobile/models/event_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class EventsDatasource {
  Future<void> saveEvent(EventModel entity);
  Future<void> saveEvents(List<EventModel> entities);
  Future<List<EventModel>> getEvents();
  Future<void> deleteEvent(int id);
  Future<void> clearEvents();
}

class EventsDataSourceImpl implements EventsDatasource {
  static Database? _database;

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
  Future<void> saveEvent(EventModel entity) async {
    try {
      final db = await database;
      await db.insert(
        AppDatabase.eventTable,
        entity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      LOGGER.e(e);
    }
  }

  @override
  Future<List<EventModel>> getEvents() async {
    try {
      final db = await database;
      // final list = await db.rawQuery('SELECT * FROM ${AppDatabase.jobTable}');
      final list = await db.query(AppDatabase.eventTable);
      List<EventModel> modelList = [];

      for (var item in list) {
        modelList.add(EventModel.fromJson(item));
      }

      return modelList;
    } catch (e) {
      LOGGER.e(e);
      return [];
    }
  }

  @override
  Future<void> saveEvents(List<EventModel> entities) async {
    try {
      final db = await database;
      var batch = db.batch();

      for (var entity in entities) {
        await db.insert(
          AppDatabase.eventTable,
          entity.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      LOGGER.e(e);
    }
  }

  @override
  Future<void> clearEvents() async {
    try {
      final db = await database;
      await db.delete(AppDatabase.eventTable);
    } catch (e) {
      LOGGER.e('Error clearing events: $e');
    }
  }

  @override
  Future<void> deleteEvent(int id) async {
    try {
      final db = await database;
      await db.delete(AppDatabase.eventTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      LOGGER.e(e);
    }
  }
}
