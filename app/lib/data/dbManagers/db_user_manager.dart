import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:app/utils/app_logger.dart';
import 'package:logging/logging.dart';
import 'package:ulid/ulid.dart';

class DBUserManager {
  static Database? _database;
  static const String _databaseName = 'mufant_museum.db';
  static final Logger _logger = AppLogger.getLogger('DBUserManager');

  // Get database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // Create database tables if they don't exist
  static Future<void> _createDatabase(Database db, int version) async {
    // Create the Details table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Details (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        imageUrlOrPath TEXT NOT NULL DEFAULT '',
        notes TEXT NOT NULL DEFAULT ''
      )
    ''');

    // Create the BaseEntity table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS BaseEntity (
        id TEXT PRIMARY KEY,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        last_update_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create the User table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS User (
        id TEXT PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash BLOB NOT NULL,
        community_chat_fk TEXT,
        details_fk TEXT
      )
    ''');

    // Create the Cart table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Cart (
        id TEXT PRIMARY KEY,
        user_fk TEXT NOT NULL,
        coupon_fk TEXT,
        FOREIGN KEY (user_fk) REFERENCES User(id)
      )
    ''');
  }

  // Helper method to hash passwords
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Create new user account
  static Future<bool> createNewAccount(
    String username,
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    try {
      final db = await database;

      // Check if username or email already exists
      final existingUser = await db.query(
        'User',
        where: 'username = ? OR email = ?',
        whereArgs: [username, email],
      );

      if (existingUser.isNotEmpty) {
        return false; // User already exists
      }

      // Generate ULIDs for our entities
      final userId = Ulid().toString();
      final baseEntityId = userId; // Use same ID for the BaseEntity
      final detailsId = Ulid().toString();

      // Start a transaction
      await db.transaction((txn) async {
        // Insert into BaseEntity
        await txn.insert('BaseEntity', {
          'id': baseEntityId,
          'created_at': DateTime.now().toIso8601String(),
          'last_update_at': DateTime.now().toIso8601String(),
        });

        // Insert details if names are provided
        if (firstName != null || lastName != null) {
          String name = '';
          if (firstName != null) name += firstName;
          if (lastName != null) name += ' $lastName';
          name = name.trim();

          await txn.insert('Details', {
            'id': detailsId,
            'name': name,
            'description': 'User profile for $username',
            'imageUrlOrPath': '',
            'notes': '',
          });
        }

        // Insert user
        await txn.insert('User', {
          'id': userId,
          'username': username,
          'email': email,
          'password_hash': hashPassword(password),
          'details_fk': firstName != null || lastName != null
              ? detailsId
              : null,
        });

        // Create cart for new user
        await createCartForUser(txn, userId);
      });

      return true;
    } catch (e) {
      AppLogger.error(_logger, 'Error creating account', e);
      return false;
    }
  }

  // Create cart for user
  static Future<bool> createCartForUser(Transaction txn, String userId) async {
    try {
      final cartId = Ulid().toString();
      final baseEntityId = cartId; // Use same ID for the BaseEntity

      // Insert into BaseEntity
      await txn.insert('BaseEntity', {
        'id': baseEntityId,
        'created_at': DateTime.now().toIso8601String(),
        'last_update_at': DateTime.now().toIso8601String(),
      });

      // Insert cart
      await txn.insert('Cart', {'id': cartId, 'user_fk': userId});

      return true;
    } catch (e) {
      AppLogger.error(_logger, 'Error creating cart', e);
      return false;
    }
  }

  // Verify user credentials
  static Future<Map<String, dynamic>?> verifyCredentials(
    String usernameOrEmail,
    String password,
  ) async {
    try {
      final db = await database;

      // Find user by username or email
      final result = await db.query(
        'User',
        where: 'username = ? OR email = ?',
        whereArgs: [usernameOrEmail, usernameOrEmail],
      );

      if (result.isEmpty) {
        AppLogger.info(
          _logger,
          'No user found with username or email: $usernameOrEmail',
        );
        return null; // User not found
      }

      // Check password
      final user = result.first;
      final storedHash = user['password_hash'].toString();
      final inputHash = hashPassword(password);

      if (storedHash == inputHash) {
        AppLogger.info(
          _logger,
          'Login successful for user: ${user['username']}',
        );
        return user; // Password matches
      }

      AppLogger.info(
        _logger,
        'Password mismatch for user: ${user['username']}',
      );
      return null; // Password doesn't match
    } catch (e) {
      AppLogger.error(_logger, 'Error verifying credentials', e);
      return null;
    }
  }

  // Get user by username
  static Future<Map<String, dynamic>?> getUserByUsername(
    String username,
  ) async {
    try {
      AppLogger.info(
        AppLogger.getLogger('DBUserManager'),
        'Getting user by username: $username',
      );
      
      final db = await database;

      final result = await db.query(
        'User',
        where: 'username = ?',
        whereArgs: [username],
      );

      AppLogger.info(
        AppLogger.getLogger('DBUserManager'),
        'User query result: ${result.toString()}',
      );

      if (result.isNotEmpty) {
        final user = result.first;
        AppLogger.info(
          AppLogger.getLogger('DBUserManager'),
          'Found user: ${user.toString()}',
        );
        
        // If user has details, fetch them
        if (user['details_fk'] != null) {
          AppLogger.info(
            AppLogger.getLogger('DBUserManager'),
            'Fetching details for user with details_fk: ${user['details_fk']}',
          );
          try {
            final detailsResult = await db.query(
              'Details',
              where: 'id = ?',
              whereArgs: [user['details_fk']],
            );
            
            AppLogger.info(
              AppLogger.getLogger('DBUserManager'),
              'Details query result: ${detailsResult.toString()}',
            );
            
            if (detailsResult.isNotEmpty) {
              final details = detailsResult.first;
              // Add details to user data
              user['details'] = details;
              AppLogger.info(
                AppLogger.getLogger('DBUserManager'),
                'Details fetched: ${details.toString()}',
              );
            } else {
              AppLogger.warning(
                AppLogger.getLogger('DBUserManager'),
                'No details found for details_fk: ${user['details_fk']}',
              );
            }
          } catch (e) {
            AppLogger.warning(
              AppLogger.getLogger('DBUserManager'),
              'Error fetching details (possibly read-only): $e',
            );
            // Continue without details - will use fallback from username
          }
        } else {
          AppLogger.info(
            AppLogger.getLogger('DBUserManager'),
            'User has no details_fk: ${user['username']}',
          );
        }
        
        return user;
      }

      return null;
    } catch (e) {
      AppLogger.error(_logger, 'Error getting user by username', e);
      return null;
    }
  }

  // Update user password
  static Future<bool> updatePassword(
    String username,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final db = await database;

      // Verify old password
      final user = await verifyCredentials(username, oldPassword);
      if (user == null) {
        return false; // Old password incorrect
      }

      // Update password
      await db.update(
        'User',
        {'password_hash': hashPassword(newPassword)},
        where: 'username = ?',
        whereArgs: [username],
      );

      // Update the BaseEntity last_update_at
      await db.update(
        'BaseEntity',
        {'last_update_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [user['id']],
      );

      return true;
    } catch (e) {
      AppLogger.error(_logger, 'Error updating password', e);
      return false;
    }
  }

  // Update user email
  static Future<bool> updateEmail(
    String username,
    String password,
    String newEmail,
  ) async {
    try {
      final db = await database;

      // Verify password
      final user = await verifyCredentials(username, password);
      if (user == null) {
        return false; // Password incorrect
      }

      // Check if email already exists
      final existingEmail = await db.query(
        'User',
        where: 'email = ? AND id != ?',
        whereArgs: [newEmail, user['id']],
      );

      if (existingEmail.isNotEmpty) {
        return false; // Email already exists
      }

      // Update email
      await db.update(
        'User',
        {'email': newEmail},
        where: 'username = ?',
        whereArgs: [username],
      );

      // Update the BaseEntity last_update_at
      await db.update(
        'BaseEntity',
        {'last_update_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [user['id']],
      );

      return true;
    } catch (e) {
      AppLogger.error(_logger, 'Error updating email', e);
      return false;
    }
  }

  // Update user details
  static Future<bool> updateUserDetails(
    String username,
    String? firstName,
    String? lastName,
  ) async {
    try {
      final db = await database;

      // Get user
      final user = await getUserByUsername(username);
      if (user == null) {
        return false; // User not found
      }

      // Create name from first and last name
      String name = '';
      if (firstName != null) name += firstName;
      if (lastName != null) name += ' $lastName';
      name = name.trim();

      // Check if user has details
      if (user['details_fk'] != null) {
        // Update existing details
        await db.update(
          'Details',
          {'name': name, 'description': 'User profile for $username'},
          where: 'id = ?',
          whereArgs: [user['details_fk']],
        );
      } else {
        // Create new details
        final detailsId = Ulid().toString();
        await db.insert('Details', {
          'id': detailsId,
          'name': name,
          'description': 'User profile for $username',
          'imageUrlOrPath': '',
          'notes': '',
        });

        // Update user with details reference
        await db.update(
          'User',
          {'details_fk': detailsId},
          where: 'id = ?',
          whereArgs: [user['id']],
        );
      }

      // Update the BaseEntity last_update_at
      await db.update(
        'BaseEntity',
        {'last_update_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [user['id']],
      );

      return true;
    } catch (e) {
      AppLogger.error(_logger, 'Error updating user details', e);
      return false;
    }
  }

  // Update user details for existing users who don't have details stored
  static Future<bool> updateUserDetailsFromUsername(String username) async {
    try {

      // Get user
      final user = await getUserByUsername(username);
      if (user == null) {
        return false; // User not found
      }

      // If user already has details, no need to update
      if (user['details_fk'] != null) {
        return true;
      }

      // Extract first and last name from username
      List<String> nameParts = username.split('_');
      String? firstName;
      String? lastName;

      if (nameParts.length > 1) {
        firstName = nameParts[0];
        lastName = nameParts[1];
      } else if (nameParts.length == 1) {
        firstName = nameParts[0];
      }

      if (firstName != null) {
        return await updateUserDetails(username, firstName, lastName);
      }

      return false;
    } catch (e) {
      AppLogger.error(_logger, 'Error updating user details from username', e);
      return false;
    }
  }

  // Debug method to inspect database contents
  static Future<void> debugInspectDatabase() async {
    try {
      final db = await database;
      
      AppLogger.info(
        AppLogger.getLogger('DBUserManager'),
        '=== DATABASE INSPECTION ===',
      );
      
      // Check all users
      final users = await db.query('User');
      AppLogger.info(
        AppLogger.getLogger('DBUserManager'),
        'All users: ${users.toString()}',
      );
      
      // Check all details
      final details = await db.query('Details');
      AppLogger.info(
        AppLogger.getLogger('DBUserManager'),
        'All details: ${details.toString()}',
      );
      
      // Check all base entities
      final baseEntities = await db.query('BaseEntity');
      AppLogger.info(
        AppLogger.getLogger('DBUserManager'),
        'All base entities: ${baseEntities.toString()}',
      );
      
      AppLogger.info(
        AppLogger.getLogger('DBUserManager'),
        '=== END DATABASE INSPECTION ===',
      );
    } catch (e) {
      AppLogger.error(_logger, 'Error inspecting database', e);
    }
  }

  // Delete user account
  static Future<bool> deleteAccount(String username, String password) async {
    try {
      final db = await database;

      // Verify credentials
      final user = await verifyCredentials(username, password);
      if (user == null) {
        return false; // Invalid credentials
      }

      // Start a transaction to delete related data
      await db.transaction((txn) async {
        // Delete user's cart
        await txn.delete('Cart', where: 'user_fk = ?', whereArgs: [user['id']]);

        // Delete user's details if they exist
        if (user['details_fk'] != null) {
          await txn.delete(
            'Details',
            where: 'id = ?',
            whereArgs: [user['details_fk']],
          );
        }

        // Delete user from BaseEntity
        await txn.delete(
          'BaseEntity',
          where: 'id = ?',
          whereArgs: [user['id']],
        );

        // Delete the user
        await txn.delete('User', where: 'id = ?', whereArgs: [user['id']]);
      });

      return true;
    } catch (e) {
      AppLogger.error(_logger, 'Error deleting account', e);
      return false;
    }
  }
}
