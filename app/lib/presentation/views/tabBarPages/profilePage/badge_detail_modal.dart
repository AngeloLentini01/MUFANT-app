import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BadgeDetailModal extends StatelessWidget {
  const BadgeDetailModal({
    super.key,
    required this.color,
    this.icon,
    this.imagePath,
    required this.title,
    required this.description,
    this.achievedDate,
    this.isEarned = false,
  });

  final Color color;
  final IconData? icon;
  final String? imagePath;
  final String title;
  final String description;
  final DateTime? achievedDate;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button at top
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 24,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Large badge icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isEarned
                      ? [kBlackColor, Colors.grey[900]!]
                      : [Colors.grey[800]!, Colors.grey[600]!],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isEarned
                      ? color.withValues(alpha: 0.8)
                      : Colors.grey[600]!,
                  width: 3,
                ),
                boxShadow: isEarned
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Stack(
                children: [
                  // Badge content
                  Center(child: _buildBadgeContent()),
                  // Lock overlay for unearned badges
                  if (!isEarned)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Center(
                        child: Icon(Icons.lock, color: Colors.grey, size: 40),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Badge title with status
            Text(
              title,
              style: TextStyle(
                color: isEarned ? Colors.white : Colors.grey[400],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Achievement date
            if (isEarned && achievedDate != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Achieved on ${DateFormat('MMM dd, yyyy').format(achievedDate!)}',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Description
            Text(
              description,
              style: TextStyle(
                color: isEarned ? Colors.grey[300] : Colors.grey[500],
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            if (!isEarned) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Complete the required action to unlock this badge!',
                        style: TextStyle(
                          color: Colors.orange[300],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEarned ? color : Colors.grey[700],
                  foregroundColor: isEarned ? Colors.white : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeContent() {
    if (imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to icon if image fails to load
            return Icon(
              icon ?? Icons.star,
              color: isEarned ? color : Colors.grey[500],
              size: 60,
            );
          },
        ),
      );
    } else {
      return Icon(
        icon ?? Icons.star,
        color: isEarned ? color : Colors.grey[500],
        size: 60,
      );
    }
  }
}
