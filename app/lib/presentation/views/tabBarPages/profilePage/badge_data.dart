import 'package:flutter/material.dart';

class BadgeData {
  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final DateTime? achievedDate;

  const BadgeData({
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    this.achievedDate,
  });
}

// Sample badge data
class BadgeDataProvider {
  static const List<BadgeData> badges = [
    BadgeData(
      color: Colors.purple,
      icon: Icons.star,
      title: 'Star Collector',
      description:
          'You\'ve earned your first star by visiting 5 different exhibitions. Keep exploring to discover more amazing collections!',
    ),
    BadgeData(
      color: Colors.blue,
      icon: Icons.bookmark,
      title: 'Bookworm',
      description:
          'You\'ve bookmarked 10 interesting items. Your curiosity and desire to learn more is truly admirable!',
    ),
    BadgeData(
      color: Colors.green,
      icon: Icons.photo_camera,
      title: 'Photographer',
      description:
          'You\'ve taken photos at 3 different exhibitions. Capturing memories and sharing culture is your passion!',
    ),
    BadgeData(
      color: Colors.orange,
      icon: Icons.favorite,
      title: 'Art Lover',
      description:
          'You\'ve liked 20 different artworks. Your appreciation for art and culture shines through every interaction!',
    ),
  ];
}
