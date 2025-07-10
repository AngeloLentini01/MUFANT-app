import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/model/database/user.dart';
import 'package:app/data/dbManagers/db_user_manager.dart';
import 'package:logging/logging.dart';
import 'package:app/utils/app_logger.dart';

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
      final userData = await DBUserManager.verifyCredentials(
        username,
        password,
      );

      if (userData != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userIdKey, userData['id']);
        await prefs.setString(_usernameKey, userData['username']);
        await prefs.setString(_emailKey, userData['email']);
        await prefs.setBool(_isLoggedInKey, true);

        _currentUser = User.fromMap(userData);

        return true;
      }

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

      if (isLoggedIn) {
        final userId = prefs.getString(_userIdKey);
        final username = prefs.getString(_usernameKey);
        final email = prefs.getString(_emailKey);

        if (userId != null && username != null && email != null) {
          // Try to get the full user data from the database
          final userData = await DBUserManager.getUserByUsername(username);

          if (userData != null) {
            _currentUser = User.fromMap(userData);
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      AppLogger.error(_logger, 'Error loading session', e, StackTrace.current);
      return false;
    }
  }
}
