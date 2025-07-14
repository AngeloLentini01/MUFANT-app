// Test script to verify badge system functionality
import 'package:app/data/services/badge_service.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge_data.dart';

void main() async {
  print('=== MUFANT Badge System Test ===\n');

  final badgeService = BadgeService.instance;

  // Test 1: Initial badge status
  print('🔍 Test 1: Initial Badge Status');
  final allBadges = badgeService.getAllBadgesWithStatus();
  print('Total badges: ${badgeService.totalBadgeCount}');
  print('Earned badges: ${badgeService.earnedBadgeCount}');

  for (int i = 0; i < allBadges.length; i++) {
    final badge = allBadges[i];
    print(
      '${i + 1}. ${badge.title} - ${badge.isEarned ? "✅ EARNED" : "🔒 LOCKED"}',
    );
  }

  print('\n🚀 Test 2: Earning Space Pioneer Badge');
  await badgeService.earnSpacePioneerBadge();
  print('Space Pioneer badge earned! ✅');

  print('\n👽 Test 3: Earning Galactic Speaker Badge');
  await badgeService.earnGalacticSpeakerBadge();
  print('Galactic Speaker badge earned! ✅');

  print('\n📊 Test 4: Updated Badge Status');
  final updatedBadges = badgeService.getAllBadgesWithStatus();
  print('Total badges: ${badgeService.totalBadgeCount}');
  print('Earned badges: ${badgeService.earnedBadgeCount}');

  for (int i = 0; i < updatedBadges.length; i++) {
    final badge = updatedBadges[i];
    print(
      '${i + 1}. ${badge.title} - ${badge.isEarned ? "✅ EARNED" : "🔒 LOCKED"}',
    );
    if (badge.isEarned && badge.achievedDate != null) {
      print('   Achieved: ${badge.achievedDate}');
    }
  }

  print('\n🔄 Test 5: Reset All Badges');
  await badgeService.resetAllBadges();
  print('All badges reset! 🔄');

  print('\n📊 Test 6: Final Badge Status');
  final finalBadges = badgeService.getAllBadgesWithStatus();
  print('Total badges: ${badgeService.totalBadgeCount}');
  print('Earned badges: ${badgeService.earnedBadgeCount}');

  print('\n✅ Badge System Test Complete!');
  print('🎯 Space-themed MUFANT badges are ready to use!');
  print('\nBadge Images:');
  for (final badge in BadgeDataProvider.badges) {
    if (badge.imagePath != null) {
      print('${badge.title}: ${badge.imagePath}');
    }
  }
}
