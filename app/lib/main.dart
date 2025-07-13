import 'package:app/presentation/app_pre_configurator.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/data/dbManagers/database_helper.dart';
import 'package:app/data/dbManagers/data_migration_helper.dart';
import 'package:app/data/services/user_session_manager.dart';
import 'package:app/utils/app_logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

typedef MySystem = SystemChrome;
final Logger _logger = AppLogger.getLogger('Main');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.init();

  // Initialize database
  try {
    await DatabaseHelper.database;
    AppLogger.info(_logger, 'Database initialized successfully');

    // Check if migration is needed
    bool migrationNeeded = await _checkIfMigrationNeeded();
    if (migrationNeeded) {
      AppLogger.info(_logger, 'Starting data migration...');
      await DataMigrationHelper.migrateAllData();
      AppLogger.info(_logger, 'Data migration completed');
    }

    // Add sample data if needed
    await DatabaseHelper.initializeSampleData();

    // Initialize user session
    await UserSessionManager.loadSession();
  } catch (e) {
    AppLogger.error(_logger, 'Error initializing database', e);
  }

  // Set system UI overlay style to ensure status bar matches app theme
  MySystem.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: kBlackColor, // Using the new base color
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AppPreConfigurator());
}

Future<bool> _checkIfMigrationNeeded() async {
  try {
    // Check if old tables exist
    final db = await openDatabase(
      join(await getDatabasesPath(), 'mufant_museum.db'),
    );

    // Check if users table exists and has data
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='users'",
    );

    if (tables.isEmpty) {
      return false; // Old table doesn't exist, no migration needed
    }

    // Check if there's data to migrate
    final users = await db.query('users');
    final activities = await db.query('museum_activities');

    return users.isNotEmpty || activities.isNotEmpty;
  } catch (e) {
    debugPrint('Error checking if migration is needed: $e');
    return false;
  }
}
