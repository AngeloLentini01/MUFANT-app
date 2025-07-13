import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({super.key, required this.color, required this.icon, this.onTap});

  final Color color;
  final IconData icon;
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
            colors: [kBlackColor, Colors.grey[900]!],
          ),

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: lightGreyColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),

        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}
