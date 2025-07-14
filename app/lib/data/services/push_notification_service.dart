import 'package:flutter/foundation.dart';
import 'package:push/push.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PushNotificationService extends ChangeNotifier {
  static PushNotificationService? _instance;
  static PushNotificationService get instance =>
      _instance ??= PushNotificationService._();

  PushNotificationService._();

  // Callback functions for different notification states
  VoidCallback? _onNewTokenCallback;
  Function(Map<String, dynamic>)? _onMessageReceivedCallback;
  Function(Map<String, dynamic>)? _onNotificationTapCallback;
  Function(Map<String, dynamic>)? _onBackgroundMessageCallback;

  String? _fcmToken;
  bool _isInitialized = false;
  bool _permissionGranted = false;

  List<Map<String, dynamic>> _notificationHistory = [];

  // Getters
  String? get fcmToken => _fcmToken;
  bool get isInitialized => _isInitialized;
  bool get hasPermission => _permissionGranted;
  List<Map<String, dynamic>> get notificationHistory =>
      List.unmodifiable(_notificationHistory);

  /// Initialize the push notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load notification history from storage
      await _loadNotificationHistory();

      // Set up token listener
      Push.instance.addOnNewToken((token) {
        debugPrint("✅ New FCM registration token: $token");
        _fcmToken = token;
        _onNewTokenCallback?.call();
        notifyListeners();
      });

      // Handle notification launching app from terminated state
      Push.instance.notificationTapWhichLaunchedAppFromTerminated.then((data) {
        if (data != null) {
          debugPrint(
            '🚀 Notification tap launched app from terminated state: $data',
          );
          _handleNotificationTap(Map<String, dynamic>.from(data));
        }
      });

      // Handle notification taps when app is running
      Push.instance.addOnNotificationTap((data) {
        debugPrint('🔔 Notification was tapped: $data');
        _handleNotificationTap(Map<String, dynamic>.from(data));
      });

      // Handle push notifications when app is in foreground
      Push.instance.addOnMessage((message) {
        debugPrint(
          '📱 Message received in foreground: ${message.notification?.title}',
        );
        _handleForegroundMessage(message);
      });

      // Handle push notifications when app is in background
      Push.instance.addOnBackgroundMessage((message) {
        debugPrint(
          '🔄 Message received in background: ${message.notification?.title}',
        );
        _handleBackgroundMessage(message);
      });

      _isInitialized = true;
      notifyListeners();

      debugPrint('✅ Push notification service initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing push notifications: $e');
    }
  }

  /// Request permission to show notifications
  Future<bool> requestPermission() async {
    try {
      final isGranted = await Push.instance.requestPermission();
      _permissionGranted = isGranted;
      notifyListeners();

      if (isGranted) {
        debugPrint('✅ Push notification permission granted');
      } else {
        debugPrint('❌ Push notification permission denied');
      }

      return isGranted;
    } catch (e) {
      debugPrint('❌ Error requesting notification permission: $e');
      return false;
    }
  }

  /// Set callback for when a new FCM token is received
  void setOnNewTokenCallback(VoidCallback callback) {
    _onNewTokenCallback = callback;
  }

  /// Set callback for when a message is received in foreground
  void setOnMessageReceivedCallback(Function(Map<String, dynamic>) callback) {
    _onMessageReceivedCallback = callback;
  }

  /// Set callback for when a notification is tapped
  void setOnNotificationTapCallback(Function(Map<String, dynamic>) callback) {
    _onNotificationTapCallback = callback;
  }

  /// Set callback for when a background message is received
  void setOnBackgroundMessageCallback(Function(Map<String, dynamic>) callback) {
    _onBackgroundMessageCallback = callback;
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    final data = _remoteMessageToMap(message);
    _addToHistory(data);
    _onMessageReceivedCallback?.call(data);
  }

  /// Handle background messages
  void _handleBackgroundMessage(RemoteMessage message) {
    final data = _remoteMessageToMap(message);
    _addToHistory(data);
    _onBackgroundMessageCallback?.call(data);
  }

  /// Handle notification taps
  void _handleNotificationTap(Map<String, dynamic> data) {
    _onNotificationTapCallback?.call(data);
  }

  /// Convert RemoteMessage to Map for easier handling
  Map<String, dynamic> _remoteMessageToMap(RemoteMessage message) {
    return {
      'messageId': DateTime.now().millisecondsSinceEpoch
          .toString(), // Generate unique ID
      'title': message.notification?.title ?? '',
      'body': message.notification?.body ?? '',
      'data': message.data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'isRead': false,
    };
  }

  /// Add notification to history and save to storage
  void _addToHistory(Map<String, dynamic> notification) {
    _notificationHistory.insert(0, notification); // Add to beginning
    _saveNotificationHistory();
    notifyListeners();
  }

  /// Mark a notification as read
  void markAsRead(String messageId) {
    final index = _notificationHistory.indexWhere(
      (n) => n['messageId'] == messageId,
    );
    if (index != -1) {
      _notificationHistory[index]['isRead'] = true;
      _saveNotificationHistory();
      notifyListeners();
    }
  }

  /// Remove a notification from history
  void removeNotification(String messageId) {
    _notificationHistory.removeWhere((n) => n['messageId'] == messageId);
    _saveNotificationHistory();
    notifyListeners();
  }

  /// Clear all notifications
  void clearAllNotifications() {
    _notificationHistory.clear();
    _saveNotificationHistory();
    notifyListeners();
  }

  /// Get unread notification count
  int get unreadCount => _notificationHistory.where((n) => !n['isRead']).length;

  /// Load notification history from SharedPreferences
  Future<void> _loadNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('notification_history');
      if (historyJson != null) {
        final List<dynamic> decoded = json.decode(historyJson);
        _notificationHistory = decoded.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('❌ Error loading notification history: $e');
    }
  }

  /// Save notification history to SharedPreferences
  Future<void> _saveNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = json.encode(_notificationHistory);
      await prefs.setString('notification_history', historyJson);
    } catch (e) {
      debugPrint('❌ Error saving notification history: $e');
    }
  }

  /// Get current FCM token (useful for sending to your server)
  Future<String?> getToken() async {
    return _fcmToken;
  }

  /// Test method to simulate a local notification (for testing purposes)
  void simulateNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    final notification = {
      'messageId': 'test_${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'body': body,
      'data': data ?? {},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'isRead': false,
    };

    _addToHistory(notification);
    _onMessageReceivedCallback?.call(notification);
  }

  /// Dispose method to clean up resources
  @override
  void dispose() {
    // Note: Push package doesn't provide unsubscribe methods for listeners
    // The listeners will be automatically cleaned up when the app is destroyed
    super.dispose();
  }
}
