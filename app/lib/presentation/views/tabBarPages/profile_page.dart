import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/spacing/section.dart';
import 'package:app/presentation/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

// Color constants
const pinkColor = kPinkColor;
const blackColor = kBlackColor;
const greyColor = Color.fromARGB(255, 44, 44, 53);
const lightGreyColor = Color.fromARGB(255, 181, 181, 192);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final Logger _logger = Logger('ProfilePage');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            AppBarWidget(
              text: 'Settings',
              textColor: kWhiteColor,
              backgroundColor: kBlackColor,
              logger: _logger,
              iconImage: Icons.settings,
              onButtonPressed: () {},
              showLogo: false, // Don't show logo on profile page
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Settings button row
                  kSpaceBetweenSections,
                  // User Avatar Section
                  _buildUserAvatarSection(),

                  kSpaceBetweenSections,

                  // My Tickets Section
                  _buildMyTicketsSection(),

                  kSpaceBetweenSections,

                  // My Badges Section
                  _buildMyBadgesSection(),

                  kSpaceBetweenSections,

                  // Wallpaper Section
                  _buildWallpaperSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatarSection() {
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

              border: Border.all(
                color: greyColor.withValues(alpha: 0.5),
                width: 2,
              ),
            ),

            child: Center(
              child: Container(
                width: 120,

                height: 120,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: pinkColor.withValues(alpha: 0.2),
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

  Widget _buildMyTicketsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const Text(
              'My tickets',

              style: TextStyle(
                color: pinkColor,

                fontSize: 20,

                fontWeight: FontWeight.w600,
              ),
            ),

            TextButton(
              onPressed: () {
                // TODO: Navigate to all tickets
              },

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: const [
                  Text(
                    'See all',

                    style: TextStyle(color: lightGreyColor, fontSize: 16),
                  ),

                  SizedBox(width: 4),

                  Icon(
                    Icons.arrow_forward_ios,

                    color: lightGreyColor,

                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: greyColor,

            borderRadius: BorderRadius.circular(16),

            boxShadow: [
              BoxShadow(
                color: kBlackColor.withValues(alpha: 0.2),

                blurRadius: 8,

                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              // Barcode
              Container(
                width: 60,

                height: 80,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(8),
                ),

                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.black,

                          borderRadius: BorderRadius.circular(4),
                        ),

                        child: Column(
                          children: List.generate(
                            15,
                            (index) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 1),

                                color: index % 2 == 0
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      '29, May 2025',

                      style: TextStyle(color: lightGreyColor, fontSize: 14),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      '30 ANNI DI SAILOR',

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 16,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'piazza Riccardo Valle 5, Torino',

                      style: TextStyle(color: lightGreyColor, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const Text(
                '15:30 - 19:00',

                style: TextStyle(color: lightGreyColor, fontSize: 12),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Center(
          child: TextButton(
            onPressed: () {
              // TODO: Show ticket details
            },

            child: const Text(
              'View Details',

              style: TextStyle(color: lightGreyColor, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          'My Badges',

          style: TextStyle(
            color: pinkColor,

            fontSize: 20,

            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            _buildBadge(Colors.purple, Icons.star),

            _buildBadge(Colors.blue, Icons.bookmark),

            _buildBadge(Colors.green, Icons.photo_camera),

            _buildBadge(Colors.orange, Icons.favorite),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(Color color, IconData icon) {
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

  Widget _buildWallpaperSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const Text(
              'My Wallpapers',

              style: TextStyle(
                color: pinkColor,

                fontSize: 20,

                fontWeight: FontWeight.w600,
              ),
            ),

            TextButton(
              onPressed: () {
                // TODO: Navigate to all wallpapers
              },

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: const [
                  Text(
                    'See all',

                    style: TextStyle(color: lightGreyColor, fontSize: 16),
                  ),

                  SizedBox(width: 4),

                  Icon(
                    Icons.arrow_forward_ios,

                    color: lightGreyColor,

                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            _buildWallpaperThumbnail(Colors.purple, Icons.architecture),

            _buildWallpaperThumbnail(Colors.teal, Icons.palette),

            _buildWallpaperThumbnail(Colors.deepPurple, Icons.auto_awesome),

            _buildWallpaperThumbnail(Colors.blue, Icons.emoji_objects),
          ],
        ),
      ],
    );
  }

  Widget _buildWallpaperThumbnail(Color color, IconData icon) {
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
