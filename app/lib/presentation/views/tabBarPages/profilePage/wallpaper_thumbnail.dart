import 'package:flutter/material.dart';

class WallpaperThumbnail extends StatelessWidget {
  const WallpaperThumbnail({
    super.key,
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,

      height: 90,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [color, color.withValues(alpha: 0.7)],
        ),

        borderRadius: BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),

            blurRadius: 8,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
