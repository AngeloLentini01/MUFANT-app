import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/wallpaper_thumbnail.dart';
import 'package:flutter/material.dart';

// Import the lightGreyColor constant
const lightGreyColor = Color.fromARGB(255, 181, 181, 192);

class WallpaperSection extends StatelessWidget {
  const WallpaperSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text('My Wallpapers', style: kSectionTitleTextStyle),

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
            WallpaperThumbnail(
              imagePath: 'assets/images/wallpaper/wallpaper1.png',
              wallpaperName: 'Wallpaper 1',
            ),

            WallpaperThumbnail(
              imagePath: 'assets/images/wallpaper/wallpaper2.png',
              wallpaperName: 'Wallpaper 2',
            ),

            WallpaperThumbnail(
              imagePath: 'assets/images/wallpaper/wallpaper3.png',
              wallpaperName: 'Wallpaper 3',
            ),

            WallpaperThumbnail(
              imagePath: 'assets/images/wallpaper/wallpaper4.png',
              wallpaperName: 'Wallpaper 4',
            ),
          ],
        ),
      ],
    );
  }
}
