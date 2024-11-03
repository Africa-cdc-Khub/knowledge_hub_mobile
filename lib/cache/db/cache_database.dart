import 'package:khub_mobile/cache/db/app_database.dart';
import 'package:khub_mobile/injection_container.dart';
import 'package:sqflite/sqflite.dart';

class CacheDatabase {
  // Todo Make this a singleton
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
}