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
import 'dart:async';

typedef MySystem = SystemChrome;
final Logger _logger = AppLogger.getLogger('Main');

// Global completer to track database initialization status
final Completer<bool> _databaseInitializationCompleter = Completer<bool>();

// Public getter to check if database is ready
bool get isDatabaseReady => _databaseInitializationCompleter.isCompleted;

// Public method to wait for database initialization
Future<bool> waitForDatabaseInitialization() async {
  return await _databaseInitializationCompleter.future;
}

// Force database reset when schema version changes
Future<void> _resetDatabaseIfNeeded() async {
  try {
    final dbPath = join(await getDatabasesPath(), 'museum_app.db');
    final exists = await databaseExists(dbPath);

    if (exists) {
      AppLogger.info(_logger, 'Existing database found, checking version...');

      // Open database to check version
      final db = await openDatabase(dbPath);
      final version = await db.getVersion();
      await db.close();

      AppLogger.info(
        _logger,
        'Current database version: $version, required: 8',
      );

      // If version mismatch, delete the database to force recreation
      if (version != 8) {
        AppLogger.info(
          _logger,
          'Version mismatch, deleting database for clean recreation',
        );
        await deleteDatabase(dbPath);
      }
    }
  } catch (e) {
    AppLogger.error(_logger, 'Error checking database version', e);
    // If there's any error, try to delete the database for clean start
    try {
      final dbPath = join(await getDatabasesPath(), 'museum_app.db');
      await deleteDatabase(dbPath);
      AppLogger.info(
        _logger,
        'Database deleted for clean recreation due to error',
      );
    } catch (deleteError) {
      AppLogger.error(_logger, 'Failed to delete database', deleteError);
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.init();

  // Set system UI overlay style to ensure status bar matches app theme
  MySystem.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: kBlackColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize database asynchronously in background
  _initializeDatabaseAsync();

  // Start the app immediately without waiting for database
  runApp(const AppPreConfigurator());
}

void _initializeDatabaseAsync() async {
  try {
    AppLogger.info(_logger, 'Starting database initialization...');

    // Reset database if version mismatch
    await _resetDatabaseIfNeeded();

    // Initialize database with timeout
    await DatabaseHelper.database.timeout(
      Duration(seconds: 10),
      onTimeout: () {
        AppLogger.error(_logger, 'Database initialization timed out');
        throw TimeoutException(
          'Database initialization timeout',
          Duration(seconds: 10),
        );
      },
    );

    AppLogger.info(_logger, 'Database initialized successfully');

    // Check if migration is needed (with timeout)
    try {
      bool migrationNeeded = await _checkIfMigrationNeeded().timeout(
        Duration(seconds: 5),
        onTimeout: () {
          AppLogger.info(_logger, 'Migration check timed out, skipping');
          return false;
        },
      );

      if (migrationNeeded) {
        AppLogger.info(_logger, 'Starting data migration...');
        await DataMigrationHelper.migrateAllData();
        AppLogger.info(_logger, 'Data migration completed');
      }
    } catch (migrationError) {
      AppLogger.error(
        _logger,
        'Migration check failed, continuing without migration',
        migrationError,
      );
    }

    // Add sample data if needed
    try {
      await DatabaseHelper.initializeSampleData().timeout(
        Duration(seconds: 10),
        onTimeout: () {
          AppLogger.error(_logger, 'Sample data initialization timed out');
        },
      );
      AppLogger.info(_logger, 'Sample data initialized');
    } catch (sampleDataError) {
      AppLogger.error(
        _logger,
        'Sample data initialization failed',
        sampleDataError,
      );
    }

    // Initialize user session
    try {
      await UserSessionManager.loadSession();
      AppLogger.info(_logger, 'User session loaded');
    } catch (sessionError) {
      AppLogger.error(_logger, 'Failed to load user session', sessionError);
    }

    // Mark database as ready
    if (!_databaseInitializationCompleter.isCompleted) {
      _databaseInitializationCompleter.complete(true);
      AppLogger.info(
        _logger,
        'Database initialization completed - UI can now load data',
      );
    }
  } catch (e) {
    AppLogger.error(_logger, 'Error during database initialization', e);
    // Complete with false to indicate failure
    if (!_databaseInitializationCompleter.isCompleted) {
      _databaseInitializationCompleter.complete(false);
    }
  }
}

Future<bool> _checkIfMigrationNeeded() async {
  try {
    // Get the old database path
    final oldDbPath = join(await getDatabasesPath(), 'mufant_museum.db');

    // Check if the old database file exists
    final dbFile = await databaseExists(oldDbPath);
    if (!dbFile) {
      AppLogger.info(
        _logger,
        'Old database file does not exist, no migration needed',
      );
      return false;
    }

    // Check if old tables exist
    final db = await openDatabase(oldDbPath);

    // Check if users table exists and has data
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='users'",
    );

    if (tables.isEmpty) {
      await db.close();
      return false; // Old table doesn't exist, no migration needed
    }

    // Check if there's data to migrate
    final users = await db.query('users');
    final activities = await db.query('museum_activities');

    await db.close();

    bool hasData = users.isNotEmpty || activities.isNotEmpty;
    AppLogger.info(
      _logger,
      'Migration needed: $hasData (users: ${users.length}, activities: ${activities.length})',
    );

    return hasData;
  } catch (e) {
    AppLogger.error(_logger, 'Error checking if migration is needed', e);
    return false;
  }
}
