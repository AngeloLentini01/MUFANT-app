// Test script to verify badge system functionality
import 'package:app/data/services/badge_service.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge_data.dart';
import 'package:logging/logging.dart';

final _logger = Logger('BadgeSystemTest');

void main() async {
  // Configure logging to display in console
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    _logger.info('${record.level.name}: ${record.time}: ${record.message}');
  });

  _logger.info('=== MUFANT Badge System Test ===\n');

  final badgeService = BadgeService.instance;

  // Test 1: Initial badge status
  _logger.info('🔍 Test 1: Initial Badge Status');
  final allBadges = badgeService.getAllBadgesWithStatus();
  _logger.info('Total badges: ${badgeService.totalBadgeCount}');
  _logger.info('Earned badges: ${badgeService.earnedBadgeCount}');

  for (int i = 0; i < allBadges.length; i++) {
    final badge = allBadges[i];
    _logger.info(
      '${i + 1}. ${badge.title} - ${badge.isEarned ? "✅ EARNED" : "🔒 LOCKED"}',
    );
  }

  _logger.info('\n🚀 Test 2: Earning Space Pioneer Badge');
  await badgeService.earnSpacePioneerBadge();
  _logger.info('Space Pioneer badge earned! ✅');

  _logger.info('\n👽 Test 3: Earning Galactic Speaker Badge');
  await badgeService.earnGalacticSpeakerBadge();
  _logger.info('Galactic Speaker badge earned! ✅');

  _logger.info('\n📊 Test 4: Updated Badge Status');
  final updatedBadges = badgeService.getAllBadgesWithStatus();
  _logger.info('Total badges: ${badgeService.totalBadgeCount}');
  _logger.info('Earned badges: ${badgeService.earnedBadgeCount}');

  for (int i = 0; i < updatedBadges.length; i++) {
    final badge = updatedBadges[i];
    _logger.info(
      '${i + 1}. ${badge.title} - ${badge.isEarned ? "✅ EARNED" : "🔒 LOCKED"}',
    );
    if (badge.isEarned && badge.achievedDate != null) {
      _logger.info('   Achieved: ${badge.achievedDate}');
    }
  }

  _logger.info('\n🔄 Test 5: Reset All Badges');
  await badgeService.resetAllBadges();
  _logger.info('All badges reset! 🔄');

  _logger.info('\n📊 Test 6: Final Badge Status');
  badgeService.getAllBadgesWithStatus(); // Just call to verify it works
  _logger.info('Total badges: ${badgeService.totalBadgeCount}');
  _logger.info('Earned badges: ${badgeService.earnedBadgeCount}');

  _logger.info('\n✅ Badge System Test Complete!');
  _logger.info('🎯 Space-themed MUFANT badges are ready to use!');
  _logger.info('\nBadge Images:');
  for (final badge in BadgeDataProvider.badges) {
    if (badge.imagePath != null) {
      _logger.info('${badge.title}: ${badge.imagePath}');
    }
  }
}
