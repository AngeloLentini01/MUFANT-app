import 'package:flutter/material.dart';

class BadgeData {
  final Color color;
  final IconData? icon;
  final String? imagePath; // New field for badge images
  final String title;
  final String description;
  final DateTime? achievedDate;
  final bool isEarned; // Track if badge is earned

  const BadgeData({
    required this.color,
    this.icon,
    this.imagePath,
    required this.title,
    required this.description,
    this.achievedDate,
    this.isEarned = false,
  });

  // Copy constructor to mark badge as earned
  BadgeData earned({DateTime? date}) {
    return BadgeData(
      color: color,
      icon: icon,
      imagePath: imagePath,
      title: title,
      description: description,
      achievedDate: date ?? DateTime.now(),
      isEarned: true,
    );
  }
}

// MUFANT Museum Badge Data
class BadgeDataProvider {
  static const List<BadgeData> badges = [
    BadgeData(
      color: Color(0xFF6B46C1), // Purple for space theme
      imagePath: 'assets/images/badge/badge_space_pioner.png',
      title: '🚀 Space Pioneer',
      description:
          'You\'ve earned your first badge by purchasing your first intergalactic ticket. The journey has just begun—get ready to explore new worlds!',
      isEarned: false, // Will be dynamically set when user purchases ticket
    ),
    BadgeData(
      color: Color(0xFF10B981), // Green for communication
      imagePath: 'assets/images/badge/badge_galatic_speaker.png',
      title: '👽 Galactic Speaker',
      description:
          'You sent your first message in the community—your signal has been received! Keep connecting with explorers from across the stars.',
      isEarned: false, // Will be dynamically set when user sends first message
    ),
    BadgeData(
      color: Color(0xFF3B82F6), // Blue for time travel
      imagePath: 'assets/images/badge/badge_time_voyager.png',
      title: '⏳ Time Voyager',
      description:
          'You joined your first event and stepped through a cosmic portal. Events are opportunities—keep time-traveling through our galactic calendar.',
      isEarned: false, // Will be dynamically set when user joins first event
    ),
    BadgeData(
      color: Color(0xFFF59E0B), // Orange for identity/transformation
      imagePath: 'assets/images/badge/badge_identify_shifter.png',
      title: '🧬 Identity Shifter',
      description:
          'You\'ve modified your avatar for the first time. Your digital DNA has evolved—express yourself as only a true traveler can.',
      isEarned: false, // Will be dynamically set when user modifies avatar
    ),
  ];

  // Method to get a badge by its type
  static BadgeData? getBadgeByType(BadgeType type) {
    switch (type) {
      case BadgeType.spacePioneer:
        return badges[0];
      case BadgeType.galacticSpeaker:
        return badges[1];
      case BadgeType.timeVoyager:
        return badges[2];
      case BadgeType.identityShifter:
        return badges[3];
    }
  }

  // Method to earn a badge (returns a new earned badge)
  static BadgeData earnBadge(BadgeType type, {DateTime? achievedDate}) {
    final badge = getBadgeByType(type);
    if (badge != null) {
      return badge.earned(date: achievedDate);
    }
    throw Exception('Badge type not found: $type');
  }
}

// Enum for badge types to make badge management easier
enum BadgeType { spacePioneer, galacticSpeaker, timeVoyager, identityShifter }
