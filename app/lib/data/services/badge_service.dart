import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge_data.dart';
import 'dart:convert';

class BadgeService extends ChangeNotifier {
  static BadgeService? _instance;
  static BadgeService get instance => _instance ??= BadgeService._();

  BadgeService._();

  List<BadgeData> _earnedBadges = [];
  bool _isInitialized = false;

  // Getters
  List<BadgeData> get earnedBadges => List.unmodifiable(_earnedBadges);
  List<BadgeData> get allBadges => BadgeDataProvider.badges;
  bool get isInitialized => _isInitialized;
  int get earnedBadgeCount => _earnedBadges.length;
  int get totalBadgeCount => BadgeDataProvider.badges.length;

  /// Initialize the badge service and load earned badges
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadEarnedBadges();
      _isInitialized = true;
      notifyListeners();
      debugPrint(
        '✅ Badge service initialized with ${_earnedBadges.length} earned badges',
      );
    } catch (e) {
      debugPrint('❌ Error initializing badge service: $e');
    }
  }

  /// Check if a specific badge is earned
  bool isBadgeEarned(BadgeType type) {
    return _earnedBadges.any((badge) => _getBadgeType(badge) == type);
  }

  /// Earn a badge (if not already earned)
  Future<bool> earnBadge(BadgeType type, {DateTime? achievedDate}) async {
    try {
      // Check if badge is already earned
      if (isBadgeEarned(type)) {
        debugPrint('🏅 Badge already earned: $type');
        return false;
      }

      // Create the earned badge
      final earnedBadge = BadgeDataProvider.earnBadge(
        type,
        achievedDate: achievedDate,
      );

      // Add to earned badges list
      _earnedBadges.add(earnedBadge);

      // Save to persistent storage
      await _saveEarnedBadges();

      // Notify listeners
      notifyListeners();

      debugPrint('🎉 Badge earned: ${earnedBadge.title}');
      return true;
    } catch (e) {
      debugPrint('❌ Error earning badge $type: $e');
      return false;
    }
  }

  /// Get all badges with their earned status
  List<BadgeData> getAllBadgesWithStatus() {
    final result = BadgeDataProvider.badges.map((badge) {
      final type = _getBadgeType(badge);
      final isEarned = isBadgeEarned(type);

      if (isEarned) {
        final earnedBadge = _earnedBadges.firstWhere(
          (earned) => _getBadgeType(earned) == type,
        );
        // Ensure the earned badge keeps the original imagePath from the template
        return BadgeData(
          color: badge.color,
          icon: badge.icon,
          imagePath: badge.imagePath, // Use original imagePath
          title: badge.title,
          description: badge.description,
          achievedDate: earnedBadge.achievedDate,
          isEarned: true,
        );
      } else {
        // Return unearned badge
        return BadgeData(
          color: badge.color,
          icon: badge.icon,
          imagePath: badge.imagePath,
          title: badge.title,
          description: badge.description,
          achievedDate: null,
          isEarned: false,
        );
      }
    }).toList();

    // Debug output
    debugPrint('🎯 BadgeService: Returning ${result.length} badges');
    for (int i = 0; i < result.length; i++) {
      final badge = result[i];
      debugPrint(
        '  Badge $i: ${badge.title}, imagePath: ${badge.imagePath}, earned: ${badge.isEarned}',
      );
    }

    return result;
  }

  /// Get earned badge by type
  BadgeData? getEarnedBadge(BadgeType type) {
    try {
      return _earnedBadges.firstWhere((badge) => _getBadgeType(badge) == type);
    } catch (e) {
      return null;
    }
  }

  /// Reset all badges (for testing purposes)
  Future<void> resetAllBadges() async {
    _earnedBadges.clear();
    await _saveEarnedBadges();
    notifyListeners();
    debugPrint('🔄 All badges reset');
  }

  /// Earn a badge when user purchases first ticket
  Future<bool> earnSpacePioneerBadge() async {
    return await earnBadge(BadgeType.spacePioneer);
  }

  /// Earn a badge when user sends first message
  Future<bool> earnGalacticSpeakerBadge() async {
    return await earnBadge(BadgeType.galacticSpeaker);
  }

  /// Earn a badge when user joins first event
  Future<bool> earnTimeVoyagerBadge() async {
    return await earnBadge(BadgeType.timeVoyager);
  }

  /// Earn a badge when user modifies avatar
  Future<bool> earnIdentityShifterBadge() async {
    return await earnBadge(BadgeType.identityShifter);
  }

  /// Load earned badges from SharedPreferences
  Future<void> _loadEarnedBadges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final badgesJson = prefs.getString('earned_badges');

      if (badgesJson != null) {
        final List<dynamic> badgesList = json.decode(badgesJson);
        _earnedBadges = badgesList
            .map((badgeData) => _fromJson(badgeData))
            .toList();
      }
    } catch (e) {
      debugPrint('❌ Error loading earned badges: $e');
      _earnedBadges = [];
    }
  }

  /// Save earned badges to SharedPreferences
  Future<void> _saveEarnedBadges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final badgesJson = json.encode(
        _earnedBadges.map((badge) => _toJson(badge)).toList(),
      );
      await prefs.setString('earned_badges', badgesJson);
    } catch (e) {
      debugPrint('❌ Error saving earned badges: $e');
    }
  }

  /// Convert BadgeData to JSON
  Map<String, dynamic> _toJson(BadgeData badge) {
    return {
      'title': badge.title,
      'description': badge.description,
      'imagePath': badge.imagePath,
      'color': badge.color.toARGB32(),
      'achievedDate': badge.achievedDate?.millisecondsSinceEpoch,
      'isEarned': badge.isEarned,
    };
  }

  /// Convert JSON to BadgeData
  BadgeData _fromJson(Map<String, dynamic> json) {
    return BadgeData(
      title: json['title'],
      description: json['description'],
      imagePath: json['imagePath'],
      color: Color(json['color']),
      achievedDate: json['achievedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['achievedDate'])
          : null,
      isEarned: json['isEarned'] ?? false,
    );
  }

  /// Get badge type from badge data (based on title)
  BadgeType _getBadgeType(BadgeData badge) {
    if (badge.title.contains('Space Pioneer')) return BadgeType.spacePioneer;
    if (badge.title.contains('Galactic Speaker')) {
      return BadgeType.galacticSpeaker;
    }
    if (badge.title.contains('Time Voyager')) return BadgeType.timeVoyager;
    if (badge.title.contains('Identity Shifter')) {
      return BadgeType.identityShifter;
    }
    throw Exception('Unknown badge type: ${badge.title}');
  }

}
