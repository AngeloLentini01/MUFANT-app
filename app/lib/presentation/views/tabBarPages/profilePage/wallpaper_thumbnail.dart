import 'package:app/presentation/views/tabBarPages/profilePage/fullscreen_wallpaper_view.dart';
import 'package:flutter/material.dart';

class WallpaperThumbnail extends StatelessWidget {
  const WallpaperThumbnail({
    super.key,
    required this.imagePath,
    required this.wallpaperName,
  });

  final String imagePath;
  final String wallpaperName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to fullscreen wallpaper view
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullscreenWallpaperView(
              imagePath: imagePath,
              wallpaperName: wallpaperName,
            ),
          ),
        );
      },
      child: Container(
        width: 70,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
