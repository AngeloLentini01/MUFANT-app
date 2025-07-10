import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ulid/ulid.dart';
import 'package:logging/logging.dart';
import 'package:app/utils/app_logger.dart';

class DBMuseumActivityManager {
  static Database? _database;
  static const String _databaseName = 'mufant_museum.db';
  static final Logger _logger = AppLogger.getLogger('DBMuseumActivityManager');

  // Get database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path);
  }

  // Get all museum activities
  static Future<List<Map<String, dynamic>>> getAllActivities() async {
    try {
      final db = await database;

      // Join the tables to get the activity details
      final result = await db.rawQuery('''
        SELECT ma.id, d.name AS title, d.description, d.imageUrlOrPath AS image_path, 
               t.activity_options AS type, mad.location, 
               dr.start_date AS start_time, dr.end_date AS end_time,
               d.notes AS additional_info, 1 AS is_active,
               be.created_at, be.last_update_at AS updated_at
        FROM MuseumActivity ma
        JOIN MuseumActivityDetails mad ON ma.museum_activity_details_fk = mad.id
        JOIN Details d ON mad.details_fk = d.id
        JOIN TypeOfMuseumActivity t ON mad.type_fk = t.id
        JOIN Details td ON t.details_fk = td.id
        JOIN DateTimeRange dr ON mad.active_datetime_range_fk = dr.id
        JOIN BaseEntity be ON ma.id = be.id
        ORDER BY be.created_at DESC
      ''');

      return result;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting all activities',
        e,
        StackTrace.current,
      );
      return [];
    }
  }

  // Get activities by type (event or room)
  static Future<List<Map<String, dynamic>>> getActivitiesByType(
    String type,
  ) async {
    try {
      final db = await database;

      // Join the tables to get the activity details with type filter
      final result = await db.rawQuery(
        '''
        SELECT ma.id, d.name AS title, d.description, d.imageUrlOrPath AS image_path, 
               t.activity_options AS type, mad.location, 
               dr.start_date AS start_time, dr.end_date AS end_time,
               d.notes AS additional_info, 1 AS is_active,
               be.created_at, be.last_update_at AS updated_at
        FROM MuseumActivity ma
        JOIN MuseumActivityDetails mad ON ma.museum_activity_details_fk = mad.id
        JOIN Details d ON mad.details_fk = d.id
        JOIN TypeOfMuseumActivity t ON mad.type_fk = t.id
        JOIN Details td ON t.details_fk = td.id
        JOIN DateTimeRange dr ON mad.active_datetime_range_fk = dr.id
        JOIN BaseEntity be ON ma.id = be.id
        WHERE td.name = ?
        ORDER BY be.created_at DESC
      ''',
        [type],
      );

      return result;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting activities by type',
        e,
        StackTrace.current,
      );
      return [];
    }
  }

  // Get activity by ID
  static Future<Map<String, dynamic>?> getActivityById(String id) async {
    try {
      final db = await database;

      final result = await db.rawQuery(
        '''
        SELECT ma.id, d.name AS title, d.description, d.imageUrlOrPath AS image_path, 
               t.activity_options AS type, mad.location, 
               dr.start_date AS start_time, dr.end_date AS end_time,
               d.notes AS additional_info, 1 AS is_active,
               be.created_at, be.last_update_at AS updated_at
        FROM MuseumActivity ma
        JOIN MuseumActivityDetails mad ON ma.museum_activity_details_fk = mad.id
        JOIN Details d ON mad.details_fk = d.id
        JOIN TypeOfMuseumActivity t ON mad.type_fk = t.id
        JOIN Details td ON t.details_fk = td.id
        JOIN DateTimeRange dr ON mad.active_datetime_range_fk = dr.id
        JOIN BaseEntity be ON ma.id = be.id
        WHERE ma.id = ?
      ''',
        [id],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting activity by ID',
        e,
        StackTrace.current,
      );
      return null;
    }
  }

  // Get activity by title
  static Future<Map<String, dynamic>?> getActivityByTitle(String title) async {
    try {
      final db = await database;

      final result = await db.rawQuery(
        '''
        SELECT ma.id, d.name AS title, d.description, d.imageUrlOrPath AS image_path, 
               t.activity_options AS type, mad.location, 
               dr.start_date AS start_time, dr.end_date AS end_time,
               d.notes AS additional_info, 1 AS is_active,
               be.created_at, be.last_update_at AS updated_at
        FROM MuseumActivity ma
        JOIN MuseumActivityDetails mad ON ma.museum_activity_details_fk = mad.id
        JOIN Details d ON mad.details_fk = d.id
        JOIN TypeOfMuseumActivity t ON mad.type_fk = t.id
        JOIN Details td ON t.details_fk = td.id
        JOIN DateTimeRange dr ON mad.active_datetime_range_fk = dr.id
        JOIN BaseEntity be ON ma.id = be.id
        WHERE d.name = ?
      ''',
        [title],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting activity by title',
        e,
        StackTrace.current,
      );
      return null;
    }
  }

  // Get all rooms
  static Future<List<Map<String, dynamic>>> getAllRooms() async {
    return await getActivitiesByType('Room');
  }

  // Get all events
  static Future<List<Map<String, dynamic>>> getAllEvents() async {
    return await getActivitiesByType('Event');
  }

  // Create new activity
  static Future<bool> createActivity({
    required String title,
    required String description,
    required String type,
    required String imagePath,
    String? location,
    String? startTime,
    String? endTime,
    String? additionalInfo,
  }) async {
    try {
      final db = await database;

      // Generate ULIDs for all entities
      final activityId = Ulid().toString();
      final baseEntityId = activityId;
      final detailsId = Ulid().toString();
      final activityDetailsId = Ulid().toString();
      final typeId = Ulid().toString();
      final typeDetailsId = Ulid().toString();
      final dateTimeRangeId = Ulid().toString();

      // Create timestamp for current time
      final now = DateTime.now().toIso8601String();

      // Default end date is 1 year from now if not provided
      final endDate =
          endTime ??
          DateTime.now().add(const Duration(days: 365)).toIso8601String();

      // Start a transaction to ensure all inserts succeed or fail together
      await db.transaction((txn) async {
        // Insert into BaseEntity
        await txn.insert('BaseEntity', {
          'id': baseEntityId,
          'created_at': now,
          'last_update_at': now,
        });

        // Insert into Details for the activity
        await txn.insert('Details', {
          'id': detailsId,
          'name': title,
          'description': description,
          'imageUrlOrPath': imagePath,
          'notes': additionalInfo ?? '',
        });

        // Insert into Details for the type
        await txn.insert('Details', {
          'id': typeDetailsId,
          'name': type,
          'description': 'Type: $type',
          'imageUrlOrPath': '',
          'notes': '',
        });

        // Insert into TypeOfMuseumActivity
        await txn.insert('TypeOfMuseumActivity', {
          'id': typeId,
          'details_fk': typeDetailsId,
          'activity_options': type == 'Event' ? 'Visit' : 'GuidedTour',
        });

        // Insert into DateTimeRange
        await txn.insert('DateTimeRange', {
          'id': dateTimeRangeId,
          'start_date': startTime ?? now,
          'end_date': endDate,
        });

        // Insert into MuseumActivityDetails
        await txn.insert('MuseumActivityDetails', {
          'id': activityDetailsId,
          'location': location ?? '',
          'details_fk': detailsId,
          'type_fk': typeId,
          'active_datetime_range_fk': dateTimeRangeId,
        });

        // Insert into MuseumActivity
        await txn.insert('MuseumActivity', {
          'id': activityId,
          'museum_activity_details_fk': activityDetailsId,
        });
      });

      return true;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error creating activity',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  // Update activity
  static Future<bool> updateActivity({
    required String id,
    String? title,
    String? description,
    String? type,
    String? imagePath,
    String? location,
    String? startTime,
    String? endTime,
    String? additionalInfo,
  }) async {
    try {
      final db = await database;

      // Start a transaction to ensure all updates succeed or fail together
      await db.transaction((txn) async {
        // Get the activity details
        final activityResult = await txn.query(
          'MuseumActivity',
          where: 'id = ?',
          whereArgs: [id],
        );

        if (activityResult.isEmpty) {
          return false;
        }

        final activityDetailsId =
            activityResult.first['museum_activity_details_fk'] as String;

        // Get the details
        final activityDetailsResult = await txn.query(
          'MuseumActivityDetails',
          where: 'id = ?',
          whereArgs: [activityDetailsId],
        );

        if (activityDetailsResult.isEmpty) {
          return false;
        }

        final detailsId = activityDetailsResult.first['details_fk'] as String;
        final dateTimeRangeId =
            activityDetailsResult.first['active_datetime_range_fk'] as String;

        // Update BaseEntity
        await txn.update(
          'BaseEntity',
          {'last_update_at': DateTime.now().toIso8601String()},
          where: 'id = ?',
          whereArgs: [id],
        );

        // Update Details if needed
        if (title != null ||
            description != null ||
            imagePath != null ||
            additionalInfo != null) {
          Map<String, dynamic> detailsUpdate = {};
          if (title != null) detailsUpdate['name'] = title;
          if (description != null) detailsUpdate['description'] = description;
          if (imagePath != null) detailsUpdate['imageUrlOrPath'] = imagePath;
          if (additionalInfo != null) detailsUpdate['notes'] = additionalInfo;

          if (detailsUpdate.isNotEmpty) {
            await txn.update(
              'Details',
              detailsUpdate,
              where: 'id = ?',
              whereArgs: [detailsId],
            );
          }
        }

        // Update MuseumActivityDetails if needed
        if (location != null) {
          await txn.update(
            'MuseumActivityDetails',
            {'location': location},
            where: 'id = ?',
            whereArgs: [activityDetailsId],
          );
        }

        // Update DateTimeRange if needed
        if (startTime != null || endTime != null) {
          Map<String, dynamic> dateTimeUpdate = {};
          if (startTime != null) dateTimeUpdate['start_date'] = startTime;
          if (endTime != null) dateTimeUpdate['end_date'] = endTime;

          if (dateTimeUpdate.isNotEmpty) {
            await txn.update(
              'DateTimeRange',
              dateTimeUpdate,
              where: 'id = ?',
              whereArgs: [dateTimeRangeId],
            );
          }
        }
      });

      return true;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error updating activity',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  // Delete activity (soft delete)
  static Future<bool> deleteActivity(String id) async {
    try {
      final db = await database;

      // Instead of setting a flag, we'll actually remove the entity
      // We could implement a soft delete by adding an 'is_active' field to MuseumActivityDetails

      // For now, we'll just mark the BaseEntity as deleted by setting a timestamp
      final result = await db.update(
        'BaseEntity',
        {'last_update_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );

      return result > 0;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error deleting activity',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  // Search activities
  static Future<List<Map<String, dynamic>>> searchActivities(
    String query,
  ) async {
    try {
      final db = await database;

      final result = await db.rawQuery(
        '''
        SELECT ma.id, d.name AS title, d.description, d.imageUrlOrPath AS image_path, 
               t.activity_options AS type, mad.location, 
               dr.start_date AS start_time, dr.end_date AS end_time,
               d.notes AS additional_info, 1 AS is_active,
               be.created_at, be.last_update_at AS updated_at
        FROM MuseumActivity ma
        JOIN MuseumActivityDetails mad ON ma.museum_activity_details_fk = mad.id
        JOIN Details d ON mad.details_fk = d.id
        JOIN TypeOfMuseumActivity t ON mad.type_fk = t.id
        JOIN Details td ON t.details_fk = td.id
        JOIN DateTimeRange dr ON mad.active_datetime_range_fk = dr.id
        JOIN BaseEntity be ON ma.id = be.id
        WHERE d.name LIKE ? OR d.description LIKE ?
        ORDER BY be.created_at DESC
      ''',
        ['%$query%', '%$query%'],
      );

      return result;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error searching activities',
        e,
        StackTrace.current,
      );
      return [];
    }
  }
}
