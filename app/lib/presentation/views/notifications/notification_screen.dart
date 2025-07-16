import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationItem {
  final String title;
  final String body;
  final DateTime date;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'quiz_unlocked'.tr(),
      body: 'quiz_description'.tr(),
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    NotificationItem(
      title: 'visit_starts'.tr(),
      body: 'visit_description'.tr(),
      date: DateTime.now().subtract(Duration(hours: 2)),
    ),
    NotificationItem(
      title: 'new_exhibit'.tr(),
      body: 'exhibit_description'.tr(),
      date: DateTime.now(),
    ),
  ];

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'today'.tr();
    } else if (date.day == now.subtract(Duration(days: 1)).day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'yesterday'.tr();
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _markAsRead(NotificationItem item) {
    setState(() {
      item.isRead = true;
    });
  }

  void _deleteNotification(NotificationItem item) {
    setState(() {
      _notifications.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor, size: 24),
        ),
        title: Text(
          'notifications'.tr(),
          style: const TextStyle(color: Colors.white), // Titolo bianco
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: badges.Badge(
              showBadge: _notifications.any((n) => !n.isRead),
              badgeContent: Text(
                '${_notifications.where((n) => !n.isRead).length}',
                style: TextStyle(color: Colors.white, fontSize: 12),
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
