import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../services/translation_service.dart';
import '../home/main_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Colors from the design
  static const Color primaryColor = Color(0xFF13EC6A);
  static const Color backgroundDark = Color(0xFF102217);
  static const Color surfaceDark = Color(0xFF1A2E22);

  final _authService = AuthService();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Theme-aware colors
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final surfaceColor = isDark ? const Color(0xFF1A2E22) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF102217);
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF6B7280);
    final borderColor = isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200;
    
    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              // Background Gradients
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryColor.withOpacity(0.15), Colors.transparent],
                    ),
                  ),
                ),
              ),
              
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: primaryColor.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/icon/logo.png',
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => 
                                  Icon(Icons.agriculture, color: primaryColor, size: 32),
                              ),
                            ),
                          ),
                        ),

                        Text(
                          TranslationService.tr('welcome_back'),
                          style: GoogleFonts.lexend(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          TranslationService.tr('login_subtitle'),
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            color: subtitleColor,
                          ),
                        ),
                        
                        const SizedBox(height: 40),

                        // Login Form
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(TranslationService.tr('mobile_number'), textColor),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                                        const SizedBox(width: 8),
                                        Text(
                                          '+91',
                                          style: GoogleFonts.lexend(color: textColor, fontSize: 16),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.keyboard_arrow_down, color: subtitleColor, size: 16),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _phoneController,
                                      hint: '90000 00000',
                                      keyboardType: TextInputType.phone,
                                      backgroundColor: backgroundColor,
                                      textColor: textColor,
                                      hintColor: subtitleColor,
                                      borderColor: borderColor,
                                      primaryColor: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              _buildLabel(TranslationService.tr('password'), textColor),
                              _buildTextField(
                                controller: _passwordController,
                                hint: TranslationService.tr('password'),
                                isPassword: true,
                                icon: Icons.lock_outline,
                                backgroundColor: backgroundColor,
                                textColor: textColor,
                                hintColor: subtitleColor,
                                borderColor: borderColor,
                                primaryColor: primaryColor,
                              ),

                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                  child: Text(
                                    TranslationService.tr('forgot_password'),
                                    style: GoogleFonts.lexend(color: Colors.white54, fontSize: 14),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: backgroundDark,
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading 
                                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: backgroundDark))
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          TranslationService.tr('login'),
                                          style: GoogleFonts.lexend(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.arrow_forward_rounded, size: 20),
                                      ],
                                    ),
                              ),

                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${TranslationService.tr('no_account')} ",
                                    style: GoogleFonts.lexend(color: Colors.white60),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                                      );
                                    },
                                    child: Text(
                                      TranslationService.tr('signup'),
                                      style: GoogleFonts.lexend(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.spa, color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'EMPOWERING FARMERS',
                              style: GoogleFonts.lexend(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF618971),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Color backgroundColor,
    required Color textColor,
    required Color hintColor,
    required Color borderColor,
    required Color primaryColor,
    TextInputType? keyboardType,
    bool isPassword = false,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        keyboardType: keyboardType,
        style: GoogleFonts.lexend(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.lexend(color: hintColor),
          prefixIcon: icon != null ? Icon(icon, color: primaryColor, size: 20) : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: hintColor,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    // Simulate login based on input (since we are mocking auth for now or using simple auth service)
    // For now, accept any non-empty credentials or specific test ones from AuthService logic
    
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    
    if (!mounted) return;
    
    if (_phoneController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid details')),
      );
    }
    
    setState(() => _isLoading = false);
  }
}
