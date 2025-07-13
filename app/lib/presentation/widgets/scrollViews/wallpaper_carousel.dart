import 'package:flutter/material.dart';
import 'items/wallpaper_card.dart';

class WallpaperCarousel extends StatelessWidget {
  const WallpaperCarousel({
    super.key,
    required this.wallpapers,
    required this.onWallpaperTap,
  });

  final List<Map<String, String>> wallpapers;
  final Function(String) onWallpaperTap;

  @override
  Widget build(BuildContext context) {
    if (wallpapers.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: wallpapers.map((wallpaper) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: WallpaperCard(
              imagePath: wallpaper['image'] ?? '',
              onTap: () => onWallpaperTap(wallpaper['image'] ?? ''),
            ),
          );
        }).toList(),
      ),
    );
  }
}
