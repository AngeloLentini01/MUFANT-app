import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ulid/ulid.dart';
import 'package:logging/logging.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/data/dbManagers/database_helper.dart';

class DataMigrationHelper {
  static final Logger _logger = AppLogger.getLogger('DataMigrationHelper');
  // Migrate user data from old schema to new schema
  static Future<void> migrateUsers() async {
    final oldDb = await openDatabase(
      join(await getDatabasesPath(), 'mufant_museum.db'),
    );
    final newDb = await DatabaseHelper.database;

    try {
      // Get all users from old schema
      final oldUsers = await oldDb.query('users');

      if (oldUsers.isEmpty) {
        AppLogger.info(_logger, 'No users to migrate');
        return;
      }

      // Migrate each user
      for (final oldUser in oldUsers) {
        final userId = Ulid().toString();
        final baseEntityId = userId;

        // Start a transaction
        await newDb.transaction((txn) async {
          // Insert into BaseEntity
          await txn.insert('BaseEntity', {
            'id': baseEntityId,
            'created_at':
                oldUser['created_at'] ?? DateTime.now().toIso8601String(),
            'last_update_at':
                oldUser['updated_at'] ?? DateTime.now().toIso8601String(),
          });

          // Insert user
          await txn.insert('User', {
            'id': userId,
            'username': oldUser['username'],
            'email': oldUser['email'],
            'password_hash': oldUser['password_hash'],
          });

          // Create cart for user
          final cartId = Ulid().toString();
          await txn.insert('BaseEntity', {
            'id': cartId,
            'created_at': DateTime.now().toIso8601String(),
            'last_update_at': DateTime.now().toIso8601String(),
          });

          await txn.insert('Cart', {'id': cartId, 'user_fk': userId});
        });

        AppLogger.info(_logger, 'Migrated user: ${oldUser['username']}');
      }
    } catch (e) {
      AppLogger.error(_logger, 'Error migrating users', e, StackTrace.current);
    }
  }

  // Migrate museum activities from old schema to new schema
  static Future<void> migrateMuseumActivities() async {
    final oldDb = await openDatabase(
      join(await getDatabasesPath(), 'mufant_museum.db'),
    );
    final newDb = await DatabaseHelper.database;

    try {
      // Get all activities from old schema
      final oldActivities = await oldDb.query('museum_activities');

      if (oldActivities.isEmpty) {
        AppLogger.info(_logger, 'No museum activities to migrate');
        return;
      }

      // Migrate each activity
      for (final oldActivity in oldActivities) {
        final activityId = Ulid().toString();
        final baseEntityId = activityId;
        final detailsId = Ulid().toString();
        final activityDetailsId = Ulid().toString();
        final typeId = Ulid().toString();
        final typeDetailsId = Ulid().toString();
        final dateTimeRangeId = Ulid().toString();

        // Start a transaction
        await newDb.transaction((txn) async {
          // Insert into BaseEntity
          await txn.insert('BaseEntity', {
            'id': baseEntityId,
            'created_at':
                oldActivity['created_at'] ?? DateTime.now().toIso8601String(),
            'last_update_at':
                oldActivity['updated_at'] ?? DateTime.now().toIso8601String(),
          });

          // Insert details
          await txn.insert('Details', {
            'id': detailsId,
            'name': oldActivity['title'],
            'description': oldActivity['description'] ?? '',
            'imageUrlOrPath': oldActivity['image_path'] ?? '',
            'notes': oldActivity['additional_info'] ?? '',
          });

          // Insert type details
          await txn.insert('Details', {
            'id': typeDetailsId,
            'name': oldActivity['type'] == 'event' ? 'Event' : 'Room',
            'description': 'Type: ${oldActivity['type']}',
            'imageUrlOrPath': '',
            'notes': '',
          });

          // Insert type
          await txn.insert('TypeOfMuseumActivity', {
            'id': typeId,
            'details_fk': typeDetailsId,
            'activity_options': oldActivity['type'] == 'event'
                ? 'Visit'
                : 'GuidedTour',
          });

          // Insert date time range
          final startDate =
              oldActivity['start_time'] != null &&
                  oldActivity['start_time'].toString().isNotEmpty
              ? oldActivity['start_time']
              : DateTime.now().toIso8601String();

          final endDate =
              oldActivity['end_time'] != null &&
                  oldActivity['end_time'].toString().isNotEmpty
              ? oldActivity['end_time']
              : DateTime.now().add(const Duration(days: 365)).toIso8601String();

          await txn.insert('DateTimeRange', {
            'id': dateTimeRangeId,
            'start_date': startDate,
            'end_date': endDate,
          });

          // Insert activity details
          await txn.insert('MuseumActivityDetails', {
            'id': activityDetailsId,
            'location': oldActivity['location'] ?? '',
            'details_fk': detailsId,
            'type_fk': typeId,
            'active_datetime_range_fk': dateTimeRangeId,
          });

          // Insert museum activity
          await txn.insert('MuseumActivity', {
            'id': activityId,
            'museum_activity_details_fk': activityDetailsId,
          });
        });

        AppLogger.info(_logger, 'Migrated activity: ${oldActivity['title']}');
      }
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error migrating museum activities',
        e,
        StackTrace.current,
      );
    }
  }

  // Migrate all data from old schema to new schema
  static Future<void> migrateAllData() async {
    try {
      await migrateUsers();
      await migrateMuseumActivities();
      AppLogger.info(_logger, 'Data migration completed successfully');
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error during data migration',
        e,
        StackTrace.current,
      );
    }
  }
}
