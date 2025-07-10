import 'package:app/data/services/user_session_manager.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/loginPage/login_page.dart';
import 'package:flutter/material.dart';

class ProfilePageAuth extends StatefulWidget {
  const ProfilePageAuth({super.key});

  @override
  State createState() => _ProfilePageAuthState();
}

class _ProfilePageAuthState extends State<ProfilePageAuth> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    setState(() {
      _isLoading = true;
    });

    final loggedIn = await UserSessionManager.isLoggedIn();

    setState(() {
      _isLoggedIn = loggedIn;
      _isLoading = false;
    });
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
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: _logout,
                  ),
                ],
              ),
            ),

            // Profile content
            Expanded(
              child: Center(
                child: FutureBuilder<bool>(
                  future: UserSessionManager.loadSession(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: kPinkColor);
                    }

                    final user = UserSessionManager.currentUser;

                    if (user == null) {
                      return const Text(
                        'User data not available',
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: kPinkColor,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // User options
                          _buildProfileOption(
                            Icons.confirmation_number_outlined,
                            'My Tickets',
                            () {
                              // Navigate to tickets page
                            },
                          ),
                          _buildProfileOption(
                            Icons.shopping_cart_outlined,
                            'My Cart',
                            () {
                              // Navigate to cart page
                            },
                          ),
                          _buildProfileOption(
                            Icons.payment_outlined,
                            'Payment History',
                            () {
                              // Navigate to payment history
                            },
                          ),
                          _buildProfileOption(
                            Icons.settings_outlined,
                            'Account Settings',
                            () {
                              // Navigate to account settings
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                Icon(icon, color: kPinkColor),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
