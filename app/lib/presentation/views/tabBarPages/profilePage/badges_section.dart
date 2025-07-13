import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge_data.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge_detail_modal.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge_requirements_modal.dart';
import 'package:flutter/material.dart' hide Badge;

class BadgesSection extends StatelessWidget {
  const BadgesSection({super.key});

  void _showBadgeDetail(BuildContext context, BadgeData badgeData) {
    if (badgeData.isAchieved) {
      // Show achievement details for earned badges
      showDialog(
        context: context,
        builder: (context) => BadgeDetailModal(
          color: badgeData.color,
          icon: badgeData.icon,
          title: badgeData.title,
          description: badgeData.description,
          isAchieved: badgeData.isAchieved,
        ),
      );
    } else {
      // Show requirements for unearned badges
      showDialog(
        context: context,
        builder: (context) => BadgeRequirementsModal(
          color: badgeData.color,
          icon: badgeData.icon,
          title: badgeData.title,
          requirements: badgeData.requirements,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text('My Badges', style: kSectionTitleTextStyle),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: BadgeDataProvider.badges
              .map(
                (badgeData) => Badge(
                  color: badgeData.color,
                  icon: badgeData.icon,
                  isAchieved: badgeData.isAchieved,
                  onTap: () => _showBadgeDetail(context, badgeData),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
