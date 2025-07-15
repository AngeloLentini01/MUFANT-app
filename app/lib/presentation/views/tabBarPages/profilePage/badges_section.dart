import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge_data.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge_detail_modal.dart';
import 'package:app/data/services/badge_service.dart';
import 'package:flutter/material.dart' hide Badge;

class BadgesSection extends StatefulWidget {
  const BadgesSection({super.key});

  @override
  State<BadgesSection> createState() => _BadgesSectionState();
}

class _BadgesSectionState extends State<BadgesSection> {
  late BadgeService _badgeService;

  @override
  void initState() {
    super.initState();
    _badgeService = BadgeService.instance;
    // Initialize badge service and listen to changes
    _badgeService.initialize();
    _badgeService.addListener(_onBadgesChanged);
  }

  @override
  void dispose() {
    _badgeService.removeListener(_onBadgesChanged);
    super.dispose();
  }

  void _onBadgesChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showBadgeDetail(BuildContext context, BadgeData badgeData) {
    showDialog(
      context: context,
      builder: (context) => BadgeDetailModal(
        color: badgeData.color,
        icon: badgeData.icon,
        imagePath: badgeData.imagePath,
        title: badgeData.title,
        description: badgeData.description,
        achievedDate: badgeData.achievedDate,
        isEarned: badgeData.isEarned,
      ),
    );
  }

  Widget _buildBadgeTestButtons() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Test Badge Earning (Development)',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTestButton(
              '🚀 Space',
              () => _badgeService.earnSpacePioneerBadge(),
            ),
            _buildTestButton(
              '👽 Speaker',
              () => _badgeService.earnGalacticSpeakerBadge(),
            ),
            _buildTestButton(
              '⏳ Time',
              () => _badgeService.earnTimeVoyagerBadge(),
            ),
            _buildTestButton(
              '🧬 Identity',
              () => _badgeService.earnIdentityShifterBadge(),
            ),
            _buildTestButton('🔄 Reset', () => _badgeService.resetAllBadges()),
          ],
        ),
      ],
    );
  }

  Widget _buildTestButton(String label, VoidCallback onPressed) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: Size.zero,
        ),
        child: Text(label, style: const TextStyle(fontSize: 10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if service is initialized, if not return loading state
    if (!_badgeService.isInitialized) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Badges', style: kSectionTitleTextStyle),
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    final allBadges = _badgeService.getAllBadgesWithStatus();
    final earnedCount = _badgeService.earnedBadgeCount;
    final totalCount = _badgeService.totalBadgeCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Badges', style: kSectionTitleTextStyle),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[800]?.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$earnedCount/$totalCount',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: allBadges
              .map(
                (badgeData) => Badge(
                  color: badgeData.color,
                  icon: badgeData.icon,
                  imagePath: badgeData.imagePath,
                  isEarned: badgeData.isEarned,
                  onTap: () => _showBadgeDetail(context, badgeData),
                ),
              )
              .toList(),
        ),
        // Show test buttons in debug mode
        if (const bool.fromEnvironment('dart.vm.product') == false)
          _buildBadgeTestButtons(),
      ],
    );
  }
}
