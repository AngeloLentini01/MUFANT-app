import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// A utility class for logging throughout the application.
/// This provides a consistent interface for logging and can be extended
/// to support different logging levels and destinations.
class AppLogger {
  /// Create a new logger with the given name
  static Logger getLogger(String name) {
    return Logger(name);
  }

  /// Log an error message with stack trace
  static void error(
    Logger logger,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (kReleaseMode) {
      // In release mode, we might want to send this to a crash reporting service
      logger.severe(message, error, stackTrace);
      // TODO: Add integration with a crash reporting service like Firebase Crashlytics
    } else {
      logger.severe(message, error, stackTrace);
    }
  }

  /// Log an info message
  static void info(Logger logger, String message) {
    logger.info(message);
  }

  /// Log a warning message
  static void warning(Logger logger, String message, [Object? error]) {
    logger.warning(message, error);
  }

  /// Log a debug message (only in debug mode)
  static void debug(Logger logger, String message) {
    if (!kReleaseMode) {
      logger.fine(message);
    }
  }

  /// Initialize logging for the application
  static void init() {
    Logger.root.level = kReleaseMode ? Level.INFO : Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        debugPrint('${record.level.name}: ${record.time}: ${record.message}');
        if (record.error != null) {
          debugPrint('Error: ${record.error}');
        }
        if (record.stackTrace != null) {
          debugPrint('Stack trace:\n${record.stackTrace}');
        }
      }
    });
  }
}
