import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/data/services/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final Map<String, dynamic>? data;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.data,
    this.isRead = false,
  });

  // Factory constructor to create from push notification data
  factory NotificationItem.fromPushData(Map<String, dynamic> pushData) {
    return NotificationItem(
      id:
          pushData['messageId'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: pushData['title'] ?? 'New Notification',
      body: pushData['body'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(
        pushData['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      data: pushData['data'],
      isRead: pushData['isRead'] ?? false,
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<NotificationItem> _notifications;
  late PushNotificationService _pushService;

  @override
  void initState() {
    super.initState();
    _pushService = PushNotificationService.instance;
    _initializeNotifications();
    _setupPushNotificationHandlers();
  }

  void _initializeNotifications() {
    // Create initial demo notifications
    _notifications = [
      NotificationItem(
        id: 'demo_1',
        title: '❓ Quiz unlocked: How well do you know sci-fi tech?',
        body: 'Answer all questions to win exclusive museum merch.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationItem(
        id: 'demo_2',
        title: '🛰️ Your visit starts in 30 minutes!',
        body:
            'Prepare to enter a universe of future technology and cosmic wonder.',
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationItem(
        id: 'demo_3',
        title: '🚀 New Exhibit Unlocked!',
        body:
            'Discover the secrets of Mars colonization in our latest interactive zone.',
        date: DateTime.now(),
      ),
    ];

    // Add notifications from push service history
    final pushHistory = _pushService.notificationHistory;
    for (var pushData in pushHistory) {
      _notifications.add(NotificationItem.fromPushData(pushData));
    }

    // Sort by date (newest first)
    _notifications.sort((a, b) => b.date.compareTo(a.date));
  }

  void _setupPushNotificationHandlers() {
    // Listen for new push notifications when app is in foreground
    _pushService.setOnMessageReceivedCallback((data) {
      if (mounted) {
        setState(() {
          _notifications.insert(0, NotificationItem.fromPushData(data));
        });

        // Show a snackbar for new notification
        _showNewNotificationSnackBar(data['title'] ?? 'New Notification');
      }
    });

    // Listen for background messages (when app comes back to foreground)
    _pushService.setOnBackgroundMessageCallback((data) {
      if (mounted) {
        setState(() {
          final existingIndex = _notifications.indexWhere(
            (n) => n.id == data['messageId'],
          );
          if (existingIndex == -1) {
            _notifications.insert(0, NotificationItem.fromPushData(data));
          }
        });
      }
    });

    // Handle notification taps
    _pushService.setOnNotificationTapCallback((data) {
      _handleNotificationTap(data);
    });
  }

  void _showNewNotificationSnackBar(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: kPinkColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    // Handle different notification types based on data
    if (data['data'] != null) {
      final notificationData = data['data'] as Map<String, dynamic>;
      switch (notificationData['type']) {
        case 'quiz':
          // Navigate to quiz screen
          break;
        case 'exhibit':
          // Navigate to exhibit details
          break;
        case 'visit_reminder':
          // Navigate to visit details
          break;
        default:
          break;
      }
    }
  }

  // Test method to simulate push notifications (for development)
  void _sendTestNotification() {
    final testNotifications = [
      {
        'title': '🔬 Lab Session Starting Soon!',
        'body':
            'Your booked lab session begins in 15 minutes. Don\'t miss out!',
        'data': {'type': 'lab_session', 'session_id': '123'},
      },
      {
        'title': '🎯 New Achievement Unlocked!',
        'body': 'You\'ve completed 5 exhibits. Claim your digital badge!',
        'data': {'type': 'achievement', 'badge_id': 'explorer_5'},
      },
      {
        'title': '⭐ Rate Your Experience',
        'body':
            'How was your visit today? Help us improve by sharing your feedback.',
        'data': {'type': 'feedback', 'visit_id': 'today'},
      },
      {
        'title': '🎪 Special Event Tomorrow',
        'body':
            'Join us for "Mars Colony Simulation" - a special immersive experience!',
        'data': {'type': 'event', 'event_id': 'mars_sim_2025'},
      },
    ];

    final random =
        testNotifications[(DateTime.now().millisecondsSinceEpoch %
            testNotifications.length)];
    _pushService.simulateNotification(
      title: random['title'] as String,
      body: random['body'] as String,
      data: random['data'] as Map<String, dynamic>,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    } else if (date.day == now.subtract(Duration(days: 1)).day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _markAsRead(NotificationItem item) {
    setState(() {
      item.isRead = true;
    });
    // Also mark as read in push service if it's a push notification
    _pushService.markAsRead(item.id);
  }

  void _deleteNotification(NotificationItem item) {
    setState(() {
      _notifications.remove(item);
    });
    // Also remove from push service if it's a push notification
    _pushService.removeNotification(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Back button bianco
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white), // Titolo bianco
        ),
        actions: [
          // Test notification button (for development/testing)
          IconButton(
            onPressed: _sendTestNotification,
            icon: const Icon(Icons.add_alert, color: Colors.white),
            tooltip: 'Send Test Notification',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: badges.Badge(
              showBadge: _notifications.any((n) => !n.isRead),
              badgeContent: Text(
                '${_notifications.where((n) => !n.isRead).length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
          ),
        ],
      ),
      body: AnimationLimiter(
        child: GroupedListView<NotificationItem, String>(
          elements: _notifications,
          groupBy: (item) => _formatDate(item.date),
          groupSeparatorBuilder: (String groupByValue) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              groupByValue,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (context, item) {
            return AnimationConfiguration.staggeredList(
              position: _notifications.indexOf(item),
              duration: const Duration(milliseconds: 300),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Slidable(
                    key: ValueKey(item),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => _markAsRead(item),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.mark_email_read,
                          label: 'Read',
                        ),
                        SlidableAction(
                          onPressed: (_) => _deleteNotification(item),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                      color: item.isRead ? Colors.grey[100] : Colors.white,
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.body),
                        trailing: item.isRead
                            ? null
                            : Icon(Icons.circle, color: kPinkColor, size: 10),
                        onTap: () => _markAsRead(item),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          itemComparator: (a, b) => b.date.compareTo(a.date),
          useStickyGroupSeparators: true,
          floatingHeader: true,
          order: GroupedListOrder.DESC,
        ),
      ),
    );
  }
}
