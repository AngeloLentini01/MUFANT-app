import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AvatarSelectorModal extends StatefulWidget {
  const AvatarSelectorModal({
    super.key,
    required this.currentAvatarPath,
    required this.onAvatarSelected,
  });

  /// The currently selected avatar path
  final String currentAvatarPath;

  /// Callback function when an avatar is selected
  final Function(String) onAvatarSelected;

  @override
  State<AvatarSelectorModal> createState() => _AvatarSelectorModalState();
}

class _AvatarSelectorModalState extends State<AvatarSelectorModal> {
  /// List of all available avatar image paths
  static const List<String> availableAvatars = [
    'assets/images/avatar/avatar_robot.png',
    'assets/images/avatar/avatar_white_robot.png',
    'assets/images/avatar/avatar_alien.png',
    'assets/images/avatar/avatar_spacegirl.png',
    'assets/images/avatar/avatar_spiderman.png',
    'assets/images/avatar/avatar_starwars.png',
  ];

  /// Currently focused avatar path (for visual feedback)
  late String focusedAvatarPath;

  @override
  void initState() {
    super.initState();
    // Initialize focused avatar to current avatar
    focusedAvatarPath = widget.currentAvatarPath;
  }

  /// Handles avatar selection and updates the focus
  void _onAvatarTapped(String avatarPath) {
    setState(() {
      focusedAvatarPath = avatarPath;
    });

    // Call the callback to update the main avatar
    widget.onAvatarSelected(avatarPath);

    // Close the modal after selection (better UX)
    Navigator.pop(context);
  }

  /// Builds individual avatar grid item with focus ring
  Widget _buildAvatarItem(String avatarPath) {
    final bool isSelected = focusedAvatarPath == avatarPath;

    return GestureDetector(
      onTap: () => _onAvatarTapped(avatarPath),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Add white blurred outline for selected avatar
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.8),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.6),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: kBlackColor.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipOval(
          child: SizedBox(
            width: 80,
            height: 80,

            child: ClipOval(
              child: Image.asset(
                avatarPath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                // Add error handling for missing assets
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Icon(Icons.error, color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use the same gradient as other pages
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kBlackColor, Colors.grey[900]!],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modal handle/indicator
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // Title at the top center
            Center(
              child: Text(
                'choose_avatar'.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: kWhiteColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Avatar grid (3 columns)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: availableAvatars.length,
              itemBuilder: (context, index) {
                return _buildAvatarItem(availableAvatars[index]);
              },
            ),

            const SizedBox(height: 20),

            // Optional: Close button (redundant since we auto-close, but good UX)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'cancel'.tr(),
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
