import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/spacing/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/badges_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/tickets_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/user_avatar_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/wallpaper_section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/settings_page.dart';
import 'package:app/presentation/views/notifications/notification_screen.dart';
import 'package:app/presentation/views/loginPage/login_page.dart';
import 'package:app/presentation/views/loginPage/registration_page.dart';
import 'package:app/data/services/user_session_manager.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:easy_localization/easy_localization.dart';

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
  bool _isLoggedIn = false;
  bool _isLoading = true;
  String _userFirstName = '';

  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh authentication status when returning to this page
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      bool isLoggedIn = await UserSessionManager.isLoggedIn();
      String firstName = '';

      if (isLoggedIn) {
        // Load user session if not already loaded
        if (UserSessionManager.currentUser == null) {
          await UserSessionManager.loadSession();
        }

        // Get the user's first name
        if (UserSessionManager.currentUser != null) {
          final user = UserSessionManager.currentUser!;
          if (user.firstName != null && user.firstName!.isNotEmpty) {
            firstName = user.firstName!;
          } else if (user.username.isNotEmpty) {
            // Fallback to first part of username if no firstName
            List<String> nameParts = user.username.split('_');
            if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
              firstName = nameParts[0];
              // Properly capitalize the first name
              if (firstName.isNotEmpty) {
                firstName =
                    firstName[0].toUpperCase() +
                    firstName.substring(1).toLowerCase();
              }
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          _isLoggedIn = isLoggedIn;
          _userFirstName = firstName;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _userFirstName = '';
          _isLoading = false;
        });
      }
    }
  }

  String get _profileTitle {
    if (_isLoggedIn && _userFirstName.isNotEmpty) {
      return "$_userFirstName's Profile";
    }
    return 'Profile';
  }

  Future<void> _handleLogout() async {
    try {
      await UserSessionManager.logout();
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _userFirstName = ''; // Clear the first name
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('successfully_logged_out'.tr()),
            backgroundColor: pinkColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('error_logging_out'.tr()),
            backgroundColor: greyColor,
          ),
        );
      }
    }
  }

  Widget _buildLoginPrompt() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  size: 120,
                  color: pinkColor.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 24),
                Text(
                  'profile_welcome'.tr(),
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'profile_login_prompt'.tr(),
                  style: const TextStyle(
                    color: lightGreyColor,
                    fontSize: 16,
                    height: 1.5,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to login page
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LoginPage(shouldNavigateToMain: false),
                      ),
                    );

                    // If login was successful, refresh the authentication status
                    if (result == true) {
                      _checkAuthenticationStatus();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pinkColor,
                    foregroundColor: kWhiteColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'log_in'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () async {
                    // Navigate to registration page
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const RegistrationPage(shouldNavigateToMain: false),
                      ),
                    );

                    // If registration was successful, refresh the authentication status
                    if (result == true) {
                      _checkAuthenticationStatus();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: pinkColor,
                    side: const BorderSide(color: pinkColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'sign_up'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kBlackColor, Colors.grey[900]!],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: pinkColor),
          ),
        ),
      );
    }

    if (!_isLoggedIn) {
      return _buildLoginPrompt();
    }

    // Original profile page content for logged-in users
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications,
                          color: pinkColor,
                          size: 28,
                        ),
                      ),
                      Text(
                        _profileTitle,
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Show settings menu with logout option if logged in
                          if (_isLoggedIn) {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: greyColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.settings,
                                        color: pinkColor,
                                      ),
                                      title: const Text(
                                        'Settings',
                                        style: TextStyle(color: kWhiteColor),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SettingsPage(),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.logout,
                                        color: Colors.red,
                                      ),
                                      title: const Text(
                                        'Log Out',
                                        style: TextStyle(color: kWhiteColor),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _handleLogout();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            );
                          }
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
