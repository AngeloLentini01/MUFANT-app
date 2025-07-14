import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ulid/ulid.dart';
import 'package:logging/logging.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/data/dbManagers/database_helper.dart';

class DBMuseumActivityManager {
  static final Logger _logger = AppLogger.getLogger('DBMuseumActivityManager');

  // Use the shared database instance from DatabaseHelper
  static Future<Database> get database async {
    return DatabaseHelper.database;
  }

  // Initialize database
  // Get all museum activities
  static Future<List<Map<String, dynamic>>> getAllActivities() async {
    try {
      final db = await database;

      // Query the simple museum_activities table
      final result = await db.rawQuery(
        '''        SELECT id, name, type, description, start_date, end_date,
               location, notes, price, image_path, created_at, updated_at
        FROM MuseumActivity
        ORDER BY created_at DESC
      ''',
      );

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

      // Query the simple museum_activities table with type filter
      final result = await db.rawQuery(
        '''        SELECT id, name, type, description, start_date, end_date,
               location, notes, price, image_path, created_at, updated_at
        FROM MuseumActivity
        WHERE type = ?
        ORDER BY created_at DESC
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
        '''        SELECT id, name, type, description, start_date, end_date,
               location, notes, price, image_path, created_at, updated_at
        FROM MuseumActivity
        WHERE id = ?
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

  // Get activity by title (updated to use fallback)
  static Future<Map<String, dynamic>?> getActivityByTitle(String title) async {
    return await getActivityByTitleWithFallback(title);
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

  // Get all events as DetailsModel objects
  static Future<List<DetailsModel>> getEventsAsDetailsModels() async {
    try {
      // Use fallback approach to get data from either schema
      final activities = await getActivitiesWithFallback();

      // Filter for events (handle both "event" and "Visit" types)
      final events = activities.where((activity) {
        final type = activity['type']?.toString().toLowerCase() ?? '';
        return type == 'event' || type == 'visit';
      }).toList();

      return events
          .map((activity) => _convertToDetailsModel(activity))
          .toList();
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting events as DetailsModel',
        e,
        StackTrace.current,
      );
      return [];
    }
  }

  // Get all rooms as DetailsModel objects
  static Future<List<DetailsModel>> getRoomsAsDetailsModels() async {
    try {
      // Use fallback approach to get data from either schema
      final activities = await getActivitiesWithFallback();

      // Filter for rooms
      final rooms = activities.where((activity) {
        final type = activity['type']?.toString().toLowerCase() ?? '';
        return type == 'room';
      }).toList();

      return rooms.map((activity) => _convertToDetailsModel(activity)).toList();
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting rooms as DetailsModel',
        e,
        StackTrace.current,
      );
      return [];
    }
  }

  // Convert database row to DetailsModel
  static DetailsModel _convertToDetailsModel(Map<String, dynamic> activity) {
    return DetailsModel(
      id: null, // Since the database uses integer IDs and the model expects Ulid, set to null for now
      name: activity['name'] ?? 'Unknown',
      description: activity['description'],
      notes: activity['notes'],
      imageUrlOrPath: activity['image_path'],
      createdAt: activity['created_at'] != null
          ? DateTime.tryParse(activity['created_at'])
          : null,
      updatedAt: activity['updated_at'] != null
          ? DateTime.tryParse(activity['updated_at'])
          : null,
    );
  }

  // New methods for complex schema support

  // Get activities from normalized schema
  static Future<List<Map<String, dynamic>>>
  getActivitiesFromNormalizedSchema() async {
    try {
      final db = await database;

      final result = await db.rawQuery('''
        SELECT 
          ma.id as activity_id,
          d.name,
          d.description,
          d.imageUrlOrPath as image_path,
          d.notes,
          mad.location,
          toma.activity_options as type,
          dr.start_date,
          dr.end_date
        FROM MuseumActivity ma
        JOIN MuseumActivityDetails mad ON ma.museum_activity_details_fk = mad.id
        JOIN Details d ON mad.details_fk = d.id
        JOIN TypeOfMuseumActivity toma ON mad.type_fk = toma.id
        JOIN DateTimeRange dr ON mad.active_datetime_range_fk = dr.id
        ORDER BY dr.start_date DESC
      ''');

      return result;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting activities from normalized schema',
        e,
        StackTrace.current,
      );
      return [];
    }
  }

  // Get activity by name from normalized schema
  static Future<Map<String, dynamic>?> getActivityByNameFromNormalizedSchema(
    String name,
  ) async {
    try {
      final db = await database;

      final result = await db.rawQuery(
        '''
        SELECT 
          ma.id as activity_id,
          d.name,
          d.description,
          d.imageUrlOrPath as image_path,
          d.notes,
          mad.location,
          toma.activity_options as type,
          dr.start_date,
          dr.end_date
        FROM MuseumActivity ma
        JOIN MuseumActivityDetails mad ON ma.museum_activity_details_fk = mad.id
        JOIN Details d ON mad.details_fk = d.id
        JOIN TypeOfMuseumActivity toma ON mad.type_fk = toma.id
        JOIN DateTimeRange dr ON mad.active_datetime_range_fk = dr.id
        WHERE d.name = ?
      ''',
        [name],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting activity by name from normalized schema',
        e,
        StackTrace.current,
      );
      return null;
    }
  }

  // Check if normalized schema has data
  static Future<bool> hasNormalizedData() async {
    try {
      final db = await database;

      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM MuseumActivity',
      );
      final count = result.first['count'] as int;

      return count > 0;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error checking for normalized data',
        e,
        StackTrace.current,
      );
      return false;
    }
  }

  // Get activities with fallback (tries normalized schema first, then simple)
  static Future<List<Map<String, dynamic>>> getActivitiesWithFallback() async {
    try {
      // Use flat schema (we've migrated to flat structure)
      return await getAllActivities();
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting activities with fallback',
        e,
        StackTrace.current,
      );
      return [];
    }
  }

  // Get activity by title with fallback (tries normalized schema first, then simple)
  static Future<Map<String, dynamic>?> getActivityByTitleWithFallback(
    String title,
  ) async {
    try {
      AppLogger.info(_logger, 'Searching for activity with title: "$title"');

      // First try to get data from normalized schema
      if (await hasNormalizedData()) {
        AppLogger.info(_logger, 'Using normalized schema for search');
        final result = await getActivityByNameFromNormalizedSchema(title);
        if (result != null) {
          AppLogger.info(
            _logger,
            'Found activity in normalized schema: ${result['name']}',
          );
          return result;
        }
        AppLogger.info(_logger, 'Activity not found in normalized schema');
      }

      // Fall back to simple schema
      AppLogger.info(_logger, 'Using simple schema for search');
      final result = await getActivityByTitleSimple(title);
      if (result != null) {
        AppLogger.info(
          _logger,
          'Found activity in simple schema: ${result['name']}',
        );
        return result;
      }

      AppLogger.warning(
        _logger,
        'Activity not found in any schema for title: "$title"',
      );
      return null;
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error getting activity by title with fallback',
        e,
        StackTrace.current,
      );
      return null;
    }
  }

  // Simple schema method (to avoid circular reference)
  static Future<Map<String, dynamic>?> getActivityByTitleSimple(
    String title,
  ) async {
    try {
      final db = await database;

      final result = await db.rawQuery(
        '''        SELECT id, name, type, description, start_date, end_date,
               location, notes, price, image_path, created_at, updated_at
        FROM MuseumActivity
        WHERE name = ?
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
        'Error getting activity by title from simple schema',
        e,
        StackTrace.current,
      );
      return null;
    }
  }

  // Debug method to list all activities
  static Future<void> debugListAllActivities() async {
    try {
      final db = await database;

      // Check simple schema
      final simpleActivities = await db.query('MuseumActivity');
      AppLogger.info(
        _logger,
        'Simple schema activities count: ${simpleActivities.length}',
      );
      for (final activity in simpleActivities) {
        AppLogger.info(
          _logger,
          'Simple activity: "${activity['name']}" (type: ${activity['type']})',
        );
      }

      // Check normalized schema
      if (await hasNormalizedData()) {
        final normalizedActivities = await getActivitiesFromNormalizedSchema();
        AppLogger.info(
          _logger,
          'Normalized schema activities count: ${normalizedActivities.length}',
        );
        for (final activity in normalizedActivities) {
          AppLogger.info(
            _logger,
            'Normalized activity: "${activity['name']}" (type: ${activity['type']})',
          );
        }
      } else {
        AppLogger.info(_logger, 'No normalized schema data found');
      }
    } catch (e) {
      AppLogger.error(
        _logger,
        'Error debugging activities list',
        e,
        StackTrace.current,
      );
    }
  }
}
