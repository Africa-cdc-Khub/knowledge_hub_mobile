import 'package:khub_mobile/injection_container.dart';
import 'package:sqflite/sqflite.dart';

import 'migration_config.dart';

///
/// An internal class which contains methods to execute the initial and
/// migration scripts.
///
/// [config] (required) the migration configuration to execute.
///
class Migrator {
  final MigrationConfig config;

  Migrator(this.config);

  Future<void> executeInitialization(DatabaseExecutor db, int version) async {
    LOGGER.d('Initializing tables...');
    if (config.initializationScript.isNotEmpty) {
      for (String script in config.initializationScript) {
        await db.execute(script.trim());
      }
    }

    if (config.migrationScripts.isNotEmpty) {
      for (String script in config.migrationScripts) {
        await db.execute(script.trim());
      }
    }
  }

  Future<void> executeMigration(
      DatabaseExecutor db, int oldVersion, int newVersion) async {
    LOGGER.d('Executing migrations....');
    assert(oldVersion < newVersion,
    'The newVersion($newVersion) should always be greater than the oldVersion($oldVersion).');
    assert(config.migrationScripts.length == newVersion - 1,
    'New version ($newVersion) requires exact ${newVersion - config.migrationScripts.length} migrations.');

    if (config.migrationScripts.isNotEmpty) {
      for (var i = oldVersion - 1; i < newVersion - 1; i++) {
        await db.execute(config.migrationScripts[i].trim());
      }
    }
  }
}
