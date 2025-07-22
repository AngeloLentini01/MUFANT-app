import 'package:flutter/material.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _soundEnabled = true;
  final double _textSize = 16.0;
  Locale _currentLocale = const Locale('en');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentLocale == const Locale('en')) {
      try {
        _currentLocale = context.locale;
      } catch (e) {
        // Fallback to English if context.locale fails
        _currentLocale = const Locale('en');
      }
    }
  }

  Future<void> _changeLanguage(Locale locale) async {
    setState(() {
      _currentLocale = locale;
    });
    await context.setLocale(locale);

    // Save locale to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'language_selection'.tr(),
            style: const TextStyle(color: kWhiteColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Radio<Locale>(
                  value: const Locale('en'),
                  groupValue: _currentLocale,
                  onChanged: (Locale? value) {
                    if (value != null) {
                      _changeLanguage(value);
                      Navigator.of(context).pop();
                    }
                  },
                  activeColor: kPinkColor,
                ),
                title: Text(
                  'english'.tr(),
                  style: const TextStyle(color: kWhiteColor),
                ),
                onTap: () {
                  _changeLanguage(const Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Radio<Locale>(
                  value: const Locale('it'),
                  groupValue: _currentLocale,
                  onChanged: (Locale? value) {
                    if (value != null) {
                      _changeLanguage(value);
                      Navigator.of(context).pop();
                    }
                  },
                  activeColor: kPinkColor,
                ),
                title: Text(
                  'italian'.tr(),
                  style: const TextStyle(color: kWhiteColor),
                ),
                onTap: () {
                  _changeLanguage(const Locale('it'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(color: kPinkColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom app bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: kWhiteColor,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'settings_title',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ).tr(),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Settings content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Preferences Section
                      _buildSectionHeader('app_preferences'.tr()),
                      const SizedBox(height: 12),

                      // Language Picker
                      _buildSettingsTile(
                        icon: Icons.language_outlined,
                        title: 'language'.tr(),
                        subtitle: _currentLocale.languageCode == 'en'
                            ? 'english'.tr()
                            : 'italian'.tr(),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                        onTap: () => _showLanguageDialog(),
                      ),

                      _buildSettingsTile(
                        icon: Icons.notifications_outlined,
                        title: 'notifications'.tr(),
                        subtitle: 'notifications_subtitle'.tr(),
                        trailing: Switch(
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                          activeColor: kPinkColor,
                          inactiveThumbColor: Colors.grey[600],
                          inactiveTrackColor: Colors.grey[800],
                        ),
                      ),

                      _buildSettingsTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'dark_mode'.tr(),
                        subtitle: 'dark_mode_subtitle'.tr(),
                        trailing: Switch(
                          value: _darkModeEnabled,
                          onChanged: (value) {
                            setState(() {
                              _darkModeEnabled = value;
                            });
                          },
                          activeColor: kPinkColor,
                          inactiveThumbColor: Colors.grey[600],
                          inactiveTrackColor: Colors.grey[800],
                        ),
                      ),

                      _buildSettingsTile(
                        icon: Icons.volume_up_outlined,
                        title: 'sound_effects'.tr(),
                        subtitle: 'enable_sounds'.tr(),
                        trailing: Switch(
                          value: _soundEnabled,
                          onChanged: (value) {
                            setState(() {
                              _soundEnabled = value;
                            });
                          },
                          activeColor: kPinkColor,
                          inactiveThumbColor: Colors.grey[600],
                          inactiveTrackColor: Colors.grey[800],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Display Section
                      _buildSectionHeader('display'.tr()),
                      const SizedBox(height: 12),

                      // Text Size Setting - Custom layout
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[850]?.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[700]!.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: kPinkColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.text_fields,
                                  color: kPinkColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'text_size'.tr(),
                                      style: const TextStyle(
                                        color: kWhiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'adjust_text_size'.tr(),
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${_textSize.round()}sp',
                                style: const TextStyle(
                                  color: kPinkColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Account Section
                      _buildSectionHeader('account'.tr()),
                      const SizedBox(height: 12),

                      _buildSettingsTile(
                        icon: Icons.person_outline,
                        title: 'profile_settings'.tr(),
                        subtitle: 'manage_profile'.tr(),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          // Navigate to profile settings
                          _showComingSoon();
                        },
                      ),

                      _buildSettingsTile(
                        icon: Icons.security_outlined,
                        title: 'privacy_security'.tr(),
                        subtitle: 'manage_privacy'.tr(),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          // Navigate to privacy settings
                          _showComingSoon();
                        },
                      ),

                      const SizedBox(height: 24),

                      // About Section
                      _buildSectionHeader('about'.tr()),
                      const SizedBox(height: 12),

                      _buildSettingsTile(
                        icon: Icons.help_outline,
                        title: 'help_support'.tr(),
                        subtitle: 'get_help'.tr(),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          _showComingSoon();
                        },
                      ),

                      _buildSettingsTile(
                        icon: Icons.info_outline,
                        title: 'about_app'.tr(),
                        subtitle: 'version'.tr(namedArgs: {'version': '1.0.0'}),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          _showAboutDialog();
                        },
                      ),

                      _buildSettingsTile(
                        icon: Icons.rate_review_outlined,
                        title: 'rate_app'.tr(),
                        subtitle: 'rate_us'.tr(),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          _showComingSoon();
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: kPinkColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850]?.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[700]!.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kPinkColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: kPinkColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: kWhiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
        trailing: trailing,
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'This feature is coming soon!',
          style: TextStyle(color: kWhiteColor),
        ),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'About MUFANT',
            style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MUFANT - Museum of Future and Technology',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Version: 1.0.0\nBuild: 1\n\nStay connected to geek communities and events, buy tickets in a click, and explore the future of technology.',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPinkColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kPinkColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Text(
                  '© 2025 MUFANT Team',
                  style: TextStyle(
                    color: kPinkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(
                  color: kPinkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
