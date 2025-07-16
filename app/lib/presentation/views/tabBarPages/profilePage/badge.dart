import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    super.key,
    required this.color,
    this.icon,
    this.imagePath,
    this.isEarned = false,
    this.onTap,
  });

  final Color color;
  final IconData? icon;
  final String? imagePath;
  final bool isEarned;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isEarned
                ? [kBlackColor, Colors.grey[900]!]
                : [Colors.grey[800]!, Colors.grey[600]!],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEarned ? color : Colors.grey[600]!,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Main badge content
            Center(child: _buildBadgeContent()),
            // Lock overlay for unearned badges
            if (!isEarned)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(Icons.lock, color: Colors.grey, size: 24),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeContent() {
    // Debug output
    debugPrint('🔍 Badge: imagePath=$imagePath, isEarned=$isEarned');

    if (imagePath != null && imagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ Badge image error for $imagePath: $error');
            // If image fails to load, use icon fallback
            return Icon(
              icon ?? Icons.star,
              color: isEarned ? color : Colors.grey[500],
              size: 30,
            );
          },
        ),
      );
    } else {
      debugPrint('⭐ Badge: Using icon fallback (imagePath is null/empty)');
      // Use icon if no image path is provided
      return Icon(
        icon ?? Icons.star,
        color: isEarned ? color : Colors.grey[500],
        size: 30,
      );
    }
  }
}
