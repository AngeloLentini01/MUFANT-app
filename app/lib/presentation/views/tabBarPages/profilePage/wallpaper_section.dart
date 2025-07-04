import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/wallpaper_thumbnail.dart';
import 'package:flutter/material.dart';

class WallpaperSection extends StatelessWidget {
  const WallpaperSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              'My Wallpapers',

              style: kSectionTitleTextStyle,
            ),

            TextButton(
              onPressed: () {
                // TODO: Navigate to all wallpapers
              },

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: const [
                  Text(
                    'See all',

                    style: TextStyle(color: lightGreyColor, fontSize: 16),
                  ),

                  SizedBox(width: 4),

                  Icon(
                    Icons.arrow_forward_ios,

                    color: lightGreyColor,

                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            WallpaperThumbnail(color: Colors.purple, icon: Icons.architecture),

            WallpaperThumbnail(color: Colors.teal, icon: Icons.palette),

            WallpaperThumbnail(color: Colors.deepPurple, icon: Icons.auto_awesome),

            WallpaperThumbnail(color: Colors.blue, icon: Icons.emoji_objects),
          ],
        ),
      ],
    );
  }
}
