import 'package:flutter/material.dart';
import 'package:app/presentation/views/community_chats_list_page.dart';
import 'package:app/presentation/styles/colors/generic.dart';

/// Widget that provides easy access to community chats
/// Can be used in app bars, drawers, or as a standalone button
class CommunityChatsButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool showLabel;
  final VoidCallback? onPressed;

  const CommunityChatsButton({
    super.key,
    this.label,
    this.icon,
    this.showLabel = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ElevatedButton.icon(
        onPressed: onPressed ?? () => _navigateToChats(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPinkColor,
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        icon: Icon(icon ?? Icons.chat_bubble_outline, size: 20),
        label: showLabel
            ? Text(
                label ?? 'Community Chat',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void _navigateToChats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommunityChatsListPage()),
    );
  }
}

/// Floating Action Button variant for community chats
class CommunityChatsFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String tooltip;

  const CommunityChatsFloatingButton({
    super.key,
    this.onPressed,
    this.tooltip = 'Join Community Chat',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed ?? () => _navigateToChats(context),
      backgroundColor: kPinkColor,
      foregroundColor: Colors.white,
      tooltip: tooltip,
      icon: const Icon(Icons.forum),
      label: const Text('Chat', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  void _navigateToChats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommunityChatsListPage()),
    );
  }
}

/// App Bar action for community chats
class CommunityChatsAppBarAction extends StatelessWidget {
  final VoidCallback? onPressed;

  const CommunityChatsAppBarAction({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed ?? () => _navigateToChats(context),
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          tooltip: 'Community Chats',
        ),
        // Optional: Badge for unread messages
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: kPinkColor,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: const Text(
              '3', // This would come from a notification service
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToChats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommunityChatsListPage()),
    );
  }
}
