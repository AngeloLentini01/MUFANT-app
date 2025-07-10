import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  final int? id;
  final String username;
  final String email;
  final String passwordHash;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? postalCode;
  final String? country;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
    this.city,
    this.postalCode,
    this.country,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Factory constructor to create a User object from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      passwordHash: map['password_hash'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      phoneNumber: map['phone_number'],
      address: map['address'],
      city: map['city'],
      postalCode: map['postal_code'],
      country: map['country'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  // Convert a User object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
      'postal_code': postalCode,
      'country': country,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of this User with the given fields updated
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? passwordHash,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to hash a password
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
