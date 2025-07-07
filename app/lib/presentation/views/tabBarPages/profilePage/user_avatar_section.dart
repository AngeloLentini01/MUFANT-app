import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/avatar_selector_modal.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';

class UserAvatarSection extends StatefulWidget {
  const UserAvatarSection({super.key, required this.context});

  final BuildContext context;

  @override
  State<UserAvatarSection> createState() => _UserAvatarSectionState();
}

class _UserAvatarSectionState extends State<UserAvatarSection> {
  /// Dynamic avatar image path - can be changed to implement avatar switching
  String avatarImagePath = 'assets/images/avatar/avatar_robot.png';

  /// Handle avatar selection from the modal
  void _onAvatarSelected(String newAvatarPath) {
    setState(() {
      avatarImagePath = newAvatarPath;
    });
  }

  /// Opens the avatar selector modal bottom sheet
  void _openAvatarSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AvatarSelectorModal(
        currentAvatarPath: avatarImagePath,
        onAvatarSelected: _onAvatarSelected,
      ),
    );
  }

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
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x87FF84B2), // #FF84B2 with 53% opacity at the top
                  Color(0x00999999), // #999999 with 0% opacity at the bottom
                ],
              ),
              border: Border.all(
                color: greyColor.withValues(alpha: 0.5),
                width: 2,
              ),
            ),

            child: Center(
              child: Container(
                width: 120,

                height: 120,

                child: ClipOval(
                  child: Image.asset(
                    avatarImagePath,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Edit icon
          Positioned(
            top: 10,

            right: 10,

            child: GestureDetector(
              onTap: () {
                // Open avatar selector modal
                _openAvatarSelector();
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
