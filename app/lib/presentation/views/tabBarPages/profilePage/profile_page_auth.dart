import 'package:app/data/services/user_session_manager.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/loginPage/login_page.dart';
import 'package:flutter/material.dart';

class ProfilePageAuth extends StatefulWidget {
  const ProfilePageAuth({super.key});

  @override
  State createState() => _ProfilePageAuthState();
}

class _ProfilePageAuthState extends State<ProfilePageAuth>
    with WidgetsBindingObserver {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLoginStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLoginStatus();
    }
  }

  Future<void> _checkLoginStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loggedIn = await UserSessionManager.isLoggedIn();

      if (loggedIn) {
        final sessionLoaded = await UserSessionManager.loadSession();
        if (!sessionLoaded) {
          await UserSessionManager.logout();
          if (mounted) {
            setState(() {
              _isLoggedIn = false;
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (mounted) {
        setState(() {
          _isLoggedIn = loggedIn;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await UserSessionManager.logout();
    if (mounted) {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: kBlackColor,
        body: Center(child: CircularProgressIndicator(color: kPinkColor)),
      );
    }

    if (!_isLoggedIn) {
      return Scaffold(
        backgroundColor: kBlackColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Sign in to access your profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPinkColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ).then((_) => _checkLoginStatus());
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Builder(
            builder: (context) {
              final user = UserSessionManager.currentUser;

              if (user == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      const Text(
                        'User data not available',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPinkColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          _checkLoginStatus();
                        },
                        child: const Text(
                          'Reload Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: _logout,
                        child: const Text(
                          'Log out and try again',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Header with greeting and settings
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: kPinkColor,
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          'HI, ${user.username.toUpperCase()}!',
                          style: const TextStyle(
                            color: kPinkColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                          onPressed: _logout,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Large Avatar with edit button
                  Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              kPinkColor.withValues(alpha: 0.3),
                              kPinkColor.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPinkColor,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/profileAvatars/avatar_robot.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPinkColor,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: _showAvatarSelector,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: kPinkColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: kBlackColor, width: 3),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // My Tickets Section
                  _buildSection('My tickets', [_buildTicketCard()]),

                  const SizedBox(height: 30),

                  // My Badges Section
                  _buildSection('My Badges', [_buildBadgesRow()]),

                  const SizedBox(height: 30),

                  // My Wallpapers Section
                  _buildSection('My Wallpapers', [_buildWallpapersGrid()]),

                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kPinkColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See all',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTicketCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '29. May 2025',
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  '30 ANNI DI SAILOR',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 12,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'piazza Riccardo Valle 5. Torino',
                      style: TextStyle(color: Colors.black54, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '15:30 - 19:00',
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: List.generate(
                8,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 1,
                    horizontal: 8,
                  ),
                  height: 2,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesRow() {
    final badges = [
      Icons.star,
      Icons.bookmark,
      Icons.camera_alt,
      Icons.favorite,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: badges
          .map(
            (icon) => Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: kPinkColor, size: 30),
            ),
          )
          .toList(),
    );
  }

  Widget _buildWallpapersGrid() {
    final wallpapers = [
      'assets/images/wallpapers/wallpaper1.png',
      'assets/images/wallpapers/wallpaper2.png',
      'assets/images/wallpapers/wallpaper3.png',
      'assets/images/wallpapers/wallpaper4.png',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: wallpapers
          .map(
            (wallpaper) => GestureDetector(
              onTap: () => _showWallpaperPreview(wallpaper),
              child: Container(
                width: 70,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(wallpaper),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {},
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        kPinkColor.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  void _showAvatarSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: kBlackColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'CHOOSE YOUR AVATAR!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildAvatarOption(
                    'assets/images/profileAvatars/avatar_robot.png',
                  ),
                  _buildAvatarOption(
                    'assets/images/profileAvatars/avatar_white_robot.png',
                  ),
                  _buildAvatarOption(
                    'assets/images/profileAvatars/avatar_alien.png',
                  ),
                  _buildAvatarOption(
                    'assets/images/profileAvatars/avatar_spacegirl.png',
                  ),
                  _buildAvatarOption(
                    'assets/images/profileAvatars/avatar_spiderman.png',
                  ),
                  _buildAvatarOption(
                    'assets/images/profileAvatars/avatar_starwars.png',
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        // Add logic to save the selected avatar
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kPinkColor, width: 2),
        ),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPinkColor,
                ),
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showWallpaperPreview(String wallpaperPath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kPinkColor.withValues(alpha: 0.8),
                Colors.purple.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPinkColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    icon: const Icon(Icons.download, color: Colors.white),
                    label: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
