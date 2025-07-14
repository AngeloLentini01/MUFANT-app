import 'dart:async';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBAppManager {
  static Database? _database;
  static const String _databaseName = 'mufant_museum.db';
  
  static Logger logger = Logger('DBAppManager');

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

  // PAYMENT MANAGEMENT

  // Create new payment
  static Future<bool> createPayment({
    required String username,
    required int cartId,
    required double amount,
    required String paymentMethod,
    required String status,
    String? transactionId,
  }) async {
    try {
      final db = await database;

      await db.insert('payments', {
        'username': username,
        'cart_id': cartId,
        'amount': amount,
        'payment_method': paymentMethod,
        'status': status,
        'transaction_id': transactionId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return true;
    } catch (e) {
      // Use a logging framework instead of print
      // For example, using the 'logger' package:
      // import 'package:logger/logger.dart'; at the top of the file
      // final logger = Logger(); as a static field in the class

      logger.shout('Error creating payment: $e');
      return false;
    }
  }

  // Get payment by ID
  static Future<Map<String, dynamic>?> getPaymentById(int paymentId) async {
    try {
      final db = await database;
      final result = await db.query(
        'payments',
        where: 'id = ?',
        whereArgs: [paymentId],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      logger.shout('Error getting payment: $e');
      return null;
    }
  }

  // Get payments by username
  static Future<List<Map<String, dynamic>>> getPaymentsByUsername(
    String username,
  ) async {
    try {
      final db = await database;
      final result = await db.query(
        'payments',
        where: 'username = ?',
        whereArgs: [username],
        orderBy: 'created_at DESC',
      );

      return result;
    } catch (e) {
      logger.shout('Error getting payments by username: $e');
      return [];
    }
  }

  // Update payment status
  static Future<bool> updatePaymentStatus(int paymentId, String status) async {
    try {
      final db = await database;

      final result = await db.update(
        'payments',
        {'status': status, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [paymentId],
      );

      return result > 0;
    } catch (e) {
      logger.shout('Error updating payment status: $e');
      return false;
    }
  }

  // Get all payments (for admin)
  static Future<List<Map<String, dynamic>>> getAllPayments() async {
    try {
      final db = await database;
      final result = await db.query('payments', orderBy: 'created_at DESC');

      return result;
    } catch (e) {
      logger.severe('Error getting all payments: $e');
      return [];
    }
  }

  // USER STATISTICS

  // Get user purchase statistics
  static Future<Map<String, dynamic>> getUserStatistics(String username) async {
    try {
      final db = await database;

      // Get total payments made by user
      final totalPaymentsResult = await db.rawQuery(
        'SELECT COUNT(*) as total_payments, SUM(amount) as total_spent FROM payments WHERE username = ? AND status = ?',
        [username, 'completed'],
      );

      // Get total tickets purchased
      final totalTicketsResult = await db.rawQuery(
        'SELECT COUNT(*) as total_tickets FROM tickets WHERE username = ?',
        [username],
      );

      // Get cart items count
      final cartItemsResult = await db.rawQuery(
        'SELECT COUNT(*) as cart_items FROM carts WHERE username = ?',
        [username],
      );

      return {
        'total_payments': totalPaymentsResult.first['total_payments'] ?? 0,
        'total_spent': totalPaymentsResult.first['total_spent'] ?? 0.0,
        'total_tickets': totalTicketsResult.first['total_tickets'] ?? 0,
        'cart_items': cartItemsResult.first['cart_items'] ?? 0,
      };
    } catch (e) {
      logger.warning('Error getting user statistics: $e');
      return {
        'total_payments': 0,
        'total_spent': 0.0,
        'total_tickets': 0,
        'cart_items': 0,
      };
    }
  }

  // Get system statistics (for admin)
  static Future<Map<String, dynamic>> getSystemStatistics() async {
    try {
      final db = await database;

      // Get total users
      final totalUsersResult = await db.rawQuery(
        'SELECT COUNT(*) as total_users FROM users',
      );

      // Get total payments
      final totalPaymentsResult = await db.rawQuery(
        'SELECT COUNT(*) as total_payments, SUM(amount) as total_revenue FROM payments WHERE status = ?',
        ['completed'],
      );

      // Get total tickets sold
      final totalTicketsResult = await db.rawQuery(
        'SELECT COUNT(*) as total_tickets FROM tickets',
      );

      // Get pending payments
      final pendingPaymentsResult = await db.rawQuery(
        'SELECT COUNT(*) as pending_payments FROM payments WHERE status = ?',
        ['pending'],
      );

      return {
        'total_users': totalUsersResult.first['total_users'] ?? 0,
        'total_payments': totalPaymentsResult.first['total_payments'] ?? 0,
        'total_revenue': totalPaymentsResult.first['total_revenue'] ?? 0.0,
        'total_tickets': totalTicketsResult.first['total_tickets'] ?? 0,
        'pending_payments':
            pendingPaymentsResult.first['pending_payments'] ?? 0,
      };
    } catch (e) {
      logger.warning('Error getting system statistics: $e');
      return {
        'total_users': 0,
        'total_payments': 0,
        'total_revenue': 0.0,
        'total_tickets': 0,
        'pending_payments': 0,
      };
    }
  }

  // UTILITY METHODS

  // Check if user exists
  static Future<bool> userExists(String username) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      return result.isNotEmpty;
    } catch (e) {
      logger.severe('Error checking user existence: $e');
      return false;
    }
  }

  // Get user by username
  static Future<Map<String, dynamic>?> getUserByUsername(
    String username,
  ) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      logger.severe('Error getting user by username: $e');
      return null;
    }
  }

  // Delete old payments (cleanup)
  static Future<bool> deleteOldPayments(int daysOld) async {
    try {
      final db = await database;
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

      final result = await db.delete(
        'payments',
        where: 'created_at < ? AND status = ?',
        whereArgs: [cutoffDate.toIso8601String(), 'failed'],
      );

      return result > 0;
    } catch (e) {
      logger.warning('Error deleting old payments: $e');
      return false;
    }
  }
}
