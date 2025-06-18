import 'dart:convert';
import 'dart:typed_data';

import 'package:app/data/cart/cart_model.dart';
import 'package:app/data/database/tableManagers/table_manager.dart';
import 'package:app/data/generic/details_model.dart';
import 'package:app/data/generic/people/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ulid/ulid.dart';
import 'package:logging/logging.dart';

/// Table manager for user entities.
/// Handles database operations specific to users.
class UserTableManager extends TableManager<UserModel> {
  final Logger _logger = Logger('UserTableManager');
  final Database db;

  /// Creates a new user table manager
  UserTableManager(this.db) : super('users');

  @override
  Future<UserModel> create(UserModel entity) async {
    super.create(entity);
    // Implementation here
    return entity;
  }

  @override
  Future<UserModel?> read(String id) async {
    super.read(id);
    // Implementation for reading a user from the database
    // This is a placeholder implementation
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate database operation

    try {
      final ulid = Ulid.parse(id);

      // Create dummy details
      final details = DetailsModel(
        id: ulid,
        name: 'User $id',
        description: 'This is a placeholder user',
        notes: 'No additional notes',
        updatedAt: DateTime.now(),
      );

      // Create dummy cart
      final cart = CartModel(
        id: Ulid(),
        coupon: null,
        cartItems: [],
        updatedAt: DateTime.now(),
      );

      return UserModel(
        id: ulid,
        username: 'user_$id',
        email: 'user_$id@example.com',
        passwordHash: Uint8List.fromList(utf8.encode('placeholder_hash')),
        cart: cart,
        details: details,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      _logger.warning('Error parsing ULID: $e');
      return null;
    }
  }

  @override
  Future<UserModel> update(UserModel entity) async {
    super.update(entity);
    // Implementation for updating a user in the database
    // This is a placeholder implementation
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate database operation
    return entity;
  }

  @override
  Future<bool> delete(String id) async {
    super.delete(id);
    // Implementation for deleting a user from the database
    // This is a placeholder implementation
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate database operation
    return true;
  }

  @override
  Future<List<UserModel>> list() async {
    super.list();
    // Implementation for listing all users from the database
    // This is a placeholder implementation
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate database operation

    return List.generate(5, (index) {
      final ulid = Ulid();

      // Create dummy details
      final details = DetailsModel(
        id: ulid,
        name: 'User $index',
        description: 'This is a placeholder user',
        notes: 'No additional notes',
        updatedAt: DateTime.now(),
      );

      // Create dummy cart
      final cart = CartModel(
        id: Ulid(),
        coupon: null,
        cartItems: [],
        updatedAt: DateTime.now(),
      );

      return UserModel(
        id: ulid,
        username: 'user_$index',
        email: 'user_$index@example.com',
        passwordHash: Uint8List.fromList(utf8.encode('placeholder_hash')),
        cart: cart,
        details: details,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });
  }

  @override
  UserModel mapToEntity(Map<String, dynamic> row) {
    // Create required objects
    final details = DetailsModel(
      id: Ulid.parse(row['id'] as String),
      name: row['name'] as String,
      description: row['description'] as String,
      notes: row['notes'] as String,
      imageUrlOrPath: row['image_url_or_path'] as String?,
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );

    final cart = CartModel(
      id: Ulid.parse(row['id'] as String),
      coupon: null,
      cartItems: [],
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );

    return UserModel(
      id: Ulid.parse(row['id'] as String),
      username: row['username'] as String,
      email: row['email'] as String,
      passwordHash: base64Decode(row['password_hash'] as String),
      cart: cart,
      details: details,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  @override
  Map<String, dynamic> mapToRow(UserModel entity) {
    return {
      'id': entity.id.toString(),
      'username': entity.username,
      'email': entity.email,
      'password_hash': base64Encode(entity.passwordHash),
      'name': entity.details.name,
      'description': entity.details.description,
      'notes': entity.details.notes,
      'image_url_or_path': entity.details.imageUrlOrPath,
      'created_at': entity.createdAt.toIso8601String(),
      'updated_at': entity.updatedAt.toIso8601String(),
    };
  }

  // Custom methods - should not have @override
  Future<UserModel?> findById(Ulid id) async {
    try {
      final result = await db.rawQuery('SELECT * FROM User WHERE id = ?', [
        id.toString(),
      ]);
      if (result.isNotEmpty) {
        return _mapToUserModel(result.first);
      }
      return null;
    } catch (e) {
      _logger.severe('Error finding user by id: $e');
      return null;
    }
  }

  Future<bool> insert(UserModel entity) async {
    try {

      await db.insert('User', {
        'id': entity.id.toString(),
        'username': entity.username,
        'email': entity.email,
        'password_hash': entity.passwordHash,
        'details_name': entity.details.name,
        'created_at': entity.createdAt.toIso8601String(),
        'updated_at': entity.updatedAt.toIso8601String(),
      });
      return true;
    } catch (e) {
      _logger.severe('Error inserting user: $e');
      return false;
    }
  }

  // Add helper method to map database results to UserModel
  UserModel _mapToUserModel(Map<String, dynamic> map) {
    // First get details
    final details = DetailsModel(
      id: Ulid.parse(map['id']),
      name: map['details_name'] ?? 'Default Name',
      description: map['details_description'] ?? '',
      notes: map['details_notes'] ?? '',
      imageUrlOrPath: map['details_image_url'] ?? '',
      updatedAt: DateTime.parse(map['updated_at']),
    );

    // Create dummy cart
    final cart = CartModel(
      id: Ulid.parse(map['id']),
      coupon: null,
      cartItems: [],
      updatedAt: DateTime.parse(map['updated_at']),
    );

    return UserModel(
      id: Ulid.parse(map['id']),
      username: map['username'],
      email: map['email'],
      passwordHash: base64Decode(map['password_hash']),
      details: details,
      cart: cart,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
