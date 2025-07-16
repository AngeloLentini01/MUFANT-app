// Simple test to verify badge data
import 'package:app/presentation/views/tabBarPages/profilePage/badge_data.dart';
import 'package:logging/logging.dart';

void main() {
  final log = Logger('BadgeDataTest');
  log.info('Testing Badge Data Provider...');

  for (int i = 0; i < BadgeDataProvider.badges.length; i++) {
    final badge = BadgeDataProvider.badges[i];
    log.info('Badge ${i + 1}:');
    log.info('  Title: ${badge.title}');
    log.info('  ImagePath: ${badge.imagePath}');
    log.info('  Color: ${badge.color}');
    log.info('  IsEarned: ${badge.isEarned}');
    log.info('');
  }

  log.info('Testing earnBadge method...');
  final earnedBadge = BadgeDataProvider.earnBadge(BadgeType.spacePioneer);
  log.info('Earned Badge:');
  log.info('  Title: ${earnedBadge.title}');
  log.info('  ImagePath: ${earnedBadge.imagePath}');
  log.info('  IsEarned: ${earnedBadge.isEarned}');
  log.info('  AchievedDate: ${earnedBadge.achievedDate}');
}
