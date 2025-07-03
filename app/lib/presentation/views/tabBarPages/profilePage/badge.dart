import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    super.key,
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,

      height: 60,

      decoration: BoxDecoration(
        color: greyColor,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: lightGreyColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),

      child: Icon(icon, color: color, size: 30),
    );
  }
}
