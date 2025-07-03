import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badge.dart';
import 'package:flutter/material.dart' hide Badge;

class BadgesSection extends StatelessWidget {
  const BadgesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'My Badges',

          style: kSectionTitleTextStyle,
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Badge(color: Colors.purple, icon: Icons.star),

            Badge(color: Colors.blue, icon: Icons.bookmark),

            Badge(color: Colors.green, icon: Icons.photo_camera),

            Badge(color: Colors.orange, icon: Icons.favorite),
          ],
        ),
      ],
    );
  }
}
