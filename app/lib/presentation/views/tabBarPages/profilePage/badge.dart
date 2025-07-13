import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    super.key,
    required this.color,
    required this.icon,
    this.onTap,
    this.isAchieved = false,
  });

  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isAchieved;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Always allow tap, the section will decide what to show
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAchieved
                ? lightGreyColor.withValues(alpha: 0.3)
                : lightGreyColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: isAchieved ? color : color.withValues(alpha: 0.3),
              size: 30,
            ),
            if (!isAchieved)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lock,
                  color: lightGreyColor.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
