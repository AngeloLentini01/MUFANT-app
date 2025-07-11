import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/data/dbManagers/db_user_manager.dart';

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

  factory User.fromMap(Map<String, dynamic> map) {
    // Extract names from username as fallback
    String? firstName;
    String? lastName;

    String fullName = map['username']?.toString() ?? '';
    List<String> nameParts = fullName.split('_');
    if (nameParts.length > 1) {
      firstName = nameParts[0];
      lastName = nameParts[1];
    }

    return User(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      username: map['username']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      passwordHash: map['password_hash']?.toString() ?? '',
      firstName: firstName,
      lastName: lastName,
      phoneNumber: null,
      address: null,
      city: null,
      postalCode: null,
      country: null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['last_update_at'] != null
          ? DateTime.tryParse(map['last_update_at'].toString()) ??
                DateTime.now()
          : DateTime.now(),
    );
  }
}

class UserSessionManager {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _isLoggedInKey = 'is_logged_in';

  static User? _currentUser;
  static final Logger _logger = AppLogger.getLogger('UserSessionManager');

  // Get current user
  static User? get currentUser => _currentUser;

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Login user
  static Future<bool> login(String username, String password) async {
    try {
      AppLogger.info(_logger, 'Attempting login for: $username');

      final userData = await DBUserManager.verifyCredentials(
        username,
        password,
      );

      if (userData != null) {
        AppLogger.info(_logger, 'Login successful for: $username');
        AppLogger.info(_logger, 'User data: $userData');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userIdKey, userData['id']?.toString() ?? '');
        await prefs.setString(
          _usernameKey,
          userData['username']?.toString() ?? '',
        );
        await prefs.setString(_emailKey, userData['email']?.toString() ?? '');
        await prefs.setBool(_isLoggedInKey, true);

        _currentUser = User.fromMap(userData);

        AppLogger.info(
          _logger,
          'User session created: ${_currentUser?.username}',
        );
        return true;
      }

      AppLogger.info(
        _logger,
        'Login failed for: $username - Invalid credentials',
      );
      return false;
    } catch (e) {
      AppLogger.error(_logger, 'Error during login', e, StackTrace.current);
      return false;
    }
  }

  // Logout user
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_emailKey);
      await prefs.setBool(_isLoggedInKey, false);

      _currentUser = null;
    } catch (e) {
      AppLogger.error(_logger, 'Error during logout', e, StackTrace.current);
    }
  }

  // Load user session from shared preferences
  static Future<bool> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      AppLogger.info(_logger, 'Loading session, isLoggedIn: $isLoggedIn');

      if (isLoggedIn) {
        final userId = prefs.getString(_userIdKey);
        final username = prefs.getString(_usernameKey);
        final email = prefs.getString(_emailKey);

        AppLogger.info(
          _logger,
          'Session data - userId: $userId, username: $username, email: $email',
        );

        if (userId != null && username != null && email != null) {
          // Try to get the full user data from the database
          final userData = await DBUserManager.getUserByUsername(username);

          if (userData != null) {
            AppLogger.info(
              _logger,
              'User data retrieved from database: ${userData.toString()}',
            );
            _currentUser = User.fromMap(userData);
            AppLogger.info(
              _logger,
              'User session loaded: ${_currentUser?.username}',
            );
            return true;
          } else {
            AppLogger.warning(
              _logger,
              'User data not found in database for username: $username',
            );
          }
        } else {
          AppLogger.warning(
            _logger,
            'Missing user session data in preferences',
          );
        }
      }

      // Clear current user if we couldn't load the session
      _currentUser = null;
      return false;
    } catch (e) {
      AppLogger.error(_logger, 'Error loading session', e, StackTrace.current);
      _currentUser = null;
      return false;
    }
  }
}
