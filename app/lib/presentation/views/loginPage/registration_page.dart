import 'package:app/presentation/views/loginPage/login_page.dart';
import 'package:app/data/dbManagers/db_user_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  final bool shouldNavigateToMain;

  const RegistrationPage({super.key, this.shouldNavigateToMain = true});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;
  bool _isLoading = false;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create username from name and surname
      final username =
          '${_nameController.text.trim()}_${_surnameController.text.trim()}'
              .toLowerCase();

      final success = await DBUserManager.createNewAccount(
        username,
        _emailController.text.trim(),
        _passwordController.text,
        firstName: _nameController.text.trim(),
        lastName: _surnameController.text.trim(),
      );

      if (success) {
        if (mounted) {
          _showSuccessDialog();
        }
      } else {
        _showErrorDialog(
          'Registration failed. Username or email may already exist.',
        );
      }
    } catch (e) {
      _showErrorDialog('Registration failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Successful'),
        content: const Text(
          'Your account has been created successfully. You can now sign in.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              if (widget.shouldNavigateToMain) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                // Return to previous screen with success result
                Navigator.pop(context, true);
              }
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2A33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              print('AppBar back button pressed');
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'Welcome to',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      // MUFANT Logo
                      Image.asset(
                        'assets/images/logo.png',
                        width: 140,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Let\'s create your\nnew account!',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFFFF7CA3),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Name and Surname fields
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Name',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextFormField(
                                controller: _surnameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Surname',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your surname';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Email field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color: Colors.white70,
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white70,
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white54,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Repeat password field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          controller: _repeatPasswordController,
                          obscureText: _obscureRepeatPassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white70,
                            ),
                            hintText: 'Repeat password',
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureRepeatPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white54,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureRepeatPassword =
                                      !_obscureRepeatPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please repeat your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Sign up button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B3A47),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          onPressed: _isLoading ? null : _handleRegistration,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Sign up',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Divider with text
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFFF7CA3),
                              thickness: 0.7,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            'or continue with',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFFFF7CA3),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFFF7CA3),
                              thickness: 0.7,
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Social icons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon('assets/icons/login/facebook.png'),
                          const SizedBox(width: 16),
                          _buildSocialIcon('assets/icons/login/google.png'),
                          const SizedBox(width: 16),
                          _buildSocialIcon('assets/icons/login/apple.png'),
                          const SizedBox(width: 16),
                          _buildSocialIcon(
                            'assets/icons/login/abbonamento_musei.png',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // Sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You already have an account? ",
                            style: GoogleFonts.montserrat(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('Sign in button pressed from registration page');
                              if (widget.shouldNavigateToMain) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(
                                      shouldNavigateToMain: false,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Sign in',
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFFFF7CA3),
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFF7CA3), width: 1.2),
      ),
      child: Center(child: Image.asset(assetPath, width: 24, height: 24)),
    );
  }
}
