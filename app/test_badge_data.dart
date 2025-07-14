// Simple test to verify badge data
import 'package:app/presentation/views/tabBarPages/profilePage/badge_data.dart';

void main() {
  print('Testing Badge Data Provider...');

  for (int i = 0; i < BadgeDataProvider.badges.length; i++) {
    final badge = BadgeDataProvider.badges[i];
    print('Badge ${i + 1}:');
    print('  Title: ${badge.title}');
    print('  ImagePath: ${badge.imagePath}');
    print('  Color: ${badge.color}');
    print('  IsEarned: ${badge.isEarned}');
    print('');
  }

  print('Testing earnBadge method...');
  final earnedBadge = BadgeDataProvider.earnBadge(BadgeType.spacePioneer);
  print('Earned Badge:');
  print('  Title: ${earnedBadge.title}');
  print('  ImagePath: ${earnedBadge.imagePath}');
  print('  IsEarned: ${earnedBadge.isEarned}');
  print('  AchievedDate: ${earnedBadge.achievedDate}');
}
