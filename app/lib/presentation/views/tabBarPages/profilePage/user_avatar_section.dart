import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';

class UserAvatarSection extends StatelessWidget {
  const UserAvatarSection({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Avatar background circle
          Container(
            width: 200,

            height: 200,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: greyColor.withValues(alpha: 0.3),

              border: Border.all(color: greyColor.withValues(alpha: 0.3), width: 2),
            ),

            child: Center(
              child: Container(
                width: 120,

                height: 120,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: pinkColor.withValues(alpha: 0.3),
                ),

                child: const Icon(Icons.android, size: 80, color: pinkColor),
              ),
            ),
          ),

          // Edit icon
          Positioned(
            top: 10,

            right: 10,

            child: GestureDetector(
              onTap: () {
                // TODO: Implement avatar change functionality

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Change avatar functionality not yet implemented',
                    ),

                    backgroundColor: greyColor,
                  ),
                );
              },

              child: Container(
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: pinkColor,

                  boxShadow: [
                    BoxShadow(
                      color: kBlackColor.withValues(alpha: 0.3),

                      blurRadius: 8,

                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
