import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/spacing/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badges_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/tickets_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/user_avatar_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/wallpaper_section.dart';
import 'package:app/presentation/widgets/all.dart';
import 'package:flutter/material.dart' hide Badge;
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
              textColor: kWhiteColor,
              backgroundColor: kBlackColor,
              logger: _logger,
              iconImage: Icons.settings,
              text: 'Settings',
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
