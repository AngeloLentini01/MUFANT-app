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
        _earnedBadges = [];

        for (final badgeData in badgesList) {
          try {
            // Try new format first (with badgeType)
            if (badgeData['badgeType'] != null) {
              _earnedBadges.add(_fromJson(badgeData));
            } else {
              // Handle old format (with title) - migrate to new format
              final title = badgeData['title'] as String;
              BadgeType? badgeType;

              if (title.contains('Space Pioneer') ||
                  title.contains('Pioniere Spaziale')) {
                badgeType = BadgeType.spacePioneer;
              } else if (title.contains('Galactic Speaker') ||
                  title.contains('Oratore Galattico')) {
                badgeType = BadgeType.galacticSpeaker;
              } else if (title.contains('Time Voyager') ||
                  title.contains('Viaggiatore del Tempo')) {
                badgeType = BadgeType.timeVoyager;
              } else if (title.contains('Identity Shifter') ||
                  title.contains('Mutaforma Identitario')) {
                badgeType = BadgeType.identityShifter;
              }

              if (badgeType != null) {
                final badgeTemplate = BadgeDataProvider.getBadgeByType(
                  badgeType,
                );
                if (badgeTemplate != null) {
                  _earnedBadges.add(
                    BadgeData(
                      color: badgeTemplate.color,
                      icon: badgeTemplate.icon,
                      imagePath: badgeTemplate.imagePath,
                      title: badgeTemplate.title,
                      description: badgeTemplate.description,
                      achievedDate: badgeData['achievedDate'] != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                              badgeData['achievedDate'],
                            )
                          : null,
                      isEarned: badgeData['isEarned'] ?? false,
                    ),
                  );
                }
              }
            }
          } catch (e) {
            debugPrint('❌ Error loading individual badge: $e');
          }
        }

        // Save in new format to complete migration
        await _saveEarnedBadges();
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
      'badgeType': _getBadgeType(
        badge,
      ).toString(), // Store the badge type as identifier
      'achievedDate': badge.achievedDate?.millisecondsSinceEpoch,
      'isEarned': badge.isEarned,
    };
  }

  /// Convert JSON to BadgeData
  BadgeData _fromJson(Map<String, dynamic> json) {
    // Parse the badge type from string
    final badgeTypeString = json['badgeType'] as String;
    final badgeType = BadgeType.values.firstWhere(
      (type) => type.toString() == badgeTypeString,
    );

    // Get the current badge template with current language
    final badgeTemplate = BadgeDataProvider.getBadgeByType(badgeType);

    if (badgeTemplate == null) {
      throw Exception('Badge template not found for type: $badgeType');
    }

    return BadgeData(
      color: badgeTemplate.color,
      icon: badgeTemplate.icon,
      imagePath: badgeTemplate.imagePath,
      title: badgeTemplate.title, // This will be the current language
      description:
          badgeTemplate.description, // This will be the current language
      achievedDate: json['achievedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['achievedDate'])
          : null,
      isEarned: json['isEarned'] ?? false,
    );
  }

  /// Get badge type from badge data (based on comparison with template badges)
  BadgeType _getBadgeType(BadgeData badge) {
    // Compare with template badges by checking imagePath (which is unique)
    for (BadgeType type in BadgeType.values) {
      final template = BadgeDataProvider.getBadgeByType(type);
      if (template != null && template.imagePath == badge.imagePath) {
        return type;
      }
    }

    // Fallback: Check for title patterns (for backward compatibility during migration)
    if (badge.title.contains('Space Pioneer') ||
        badge.title.contains('Pioniere Spaziale')) {
      return BadgeType.spacePioneer;
    }

    if (badge.title.contains('Galactic Speaker') ||
        badge.title.contains('Oratore Galattico')) {
      return BadgeType.galacticSpeaker;
    }

    if (badge.title.contains('Time Voyager') ||
        badge.title.contains('Viaggiatore del Tempo')) {
      return BadgeType.timeVoyager;
    }

    if (badge.title.contains('Identity Shifter') ||
        badge.title.contains('Mutaforma Identitario')) {
      return BadgeType.identityShifter;
    }

    throw Exception('Unknown badge type: ${badge.title}');
  }
}
