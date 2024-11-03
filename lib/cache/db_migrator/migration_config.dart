class MigrationConfig {
  final List<String> initializationScript;
  final List<String> migrationScripts;

  MigrationConfig({required this.initializationScript, required this.migrationScripts});
}