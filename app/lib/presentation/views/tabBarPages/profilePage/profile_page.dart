import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/spacing/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badges_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/tickets_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/user_avatar_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/wallpaper_section.dart';
import 'package:flutter/material.dart' hide Badge;

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Custom header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO: Replace with navigation to notification page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Notification page not yet implemented',
                              ),
                              backgroundColor: greyColor,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications,
                          color: pinkColor,
                          size: 28,
                        ),
                      ),
                      const Text(
                        'HI, USER!',
                        style: TextStyle(
                          color: pinkColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Replace with navigation to settings page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Settings page not yet implemented',
                              ),
                              backgroundColor: greyColor,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: pinkColor,
                          size: 28,
                        ),
                      ),
                    ],
                  ),

                  kSpaceBetweenSections,
                  // User Avatar Section
                  UserAvatarSection(context: context),

                  kSpaceBetweenSections,

                  // My Tickets Section
                  TicketsSection(),

                  kSpaceBetweenSections,

                  // My Badges Section
                  BadgesSection(),

                  kSpaceBetweenSections,

                  // Wallpaper Section
                  WallpaperSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
