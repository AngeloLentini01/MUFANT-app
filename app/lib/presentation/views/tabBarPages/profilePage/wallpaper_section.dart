import 'package:app/presentation/widgets/scrollViews/wallpaper_carousel.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/fullscreen_wallpaper_view.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WallpaperSection extends StatelessWidget {
  const WallpaperSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista semplificata di wallpaper con solo l'immagine
    final wallpapers = [
      {'image': 'assets/images/wallpaper/wallpaper1.png'},
      {'image': 'assets/images/wallpaper/wallpaper2.png'},
      {'image': 'assets/images/wallpaper/wallpaper3.png'},
      {'image': 'assets/images/wallpaper/wallpaper4.png'},
      {'image': 'assets/images/wallpaper/wallpaper1.png'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'my_wallpapers'.tr(),
          style: kSectionTitleTextStyle,
        ),
        const SizedBox(height: 16),
        WallpaperCarousel(
          wallpapers: wallpapers,
          onWallpaperTap: (imagePath) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullscreenWallpaperView(
                  imagePath: imagePath,
                  wallpaperName: 'Wallpaper',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
