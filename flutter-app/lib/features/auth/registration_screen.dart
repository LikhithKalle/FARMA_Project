import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../services/translation_service.dart';
import './otp_verification_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Colors from the design
  static const Color primaryColor = Color(0xFF13EC6A);
  static const Color backgroundLight = Color(0xFFF6F8F7);
  static const Color backgroundDark = Color(0xFF102217);
  static const Color surfaceDark = Color(0xFF1A2E22);

  final _authService = AuthService();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Theme-aware colors
    final primaryColor = theme.primaryColor;
    final bgColor = theme.scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : const Color(0xFF102217);
    final cardColor = isDark ? const Color(0xFF1A2E22) : Colors.white;
    final borderColor = isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200;

    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        return Scaffold(
          backgroundColor: bgColor,
          body: Stack(
            children: [
              // Background Gradients
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 256,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryColor.withOpacity(0.1), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -96,
                right: -96,
                width: 256,
                height: 256,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        children: [
                          const SizedBox(height: 24),
                          // Header Section with Logo
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Stack(
                                    children: [
                                      // Rotated background
                                      Transform.rotate(
                                        angle: 6 * 3.14159 / 180,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: primaryColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                        ),
                                      ),
                                      // Logo Container
                                      Container(
                                        decoration: BoxDecoration(
                                          color: isDark ? surfaceDark : Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: primaryColor.withOpacity(0.1)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
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
                                    ],
                                  ),
                                ),
                                Text(
                                  TranslationService.tr('create_account'),
                                  style: GoogleFonts.lexend(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  TranslationService.tr('signup_subtitle'),
                                  style: GoogleFonts.lexend(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Form Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: borderColor),
                              boxShadow: [
                                 BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(TranslationService.tr('full_name'), textColor),
                                _buildTextField(
                                  controller: _nameController,
                                  hint: TranslationService.tr('enter_name'),
                                  icon: Icons.person_outline,
                                  isDark: isDark,
                                  backgroundColor: bgColor,
                                  textColor: textColor,
                                  hintColor: isDark ? Colors.white30 : Colors.grey,
                                  borderColor: borderColor,
                                  primaryColor: primaryColor,
                                ),
                                const SizedBox(height: 20),
                                
                                _buildLabel(TranslationService.tr('mobile_number'), textColor),
                                Row(
                                  children: [
                                    Container(
                                      width: 100, // Kept 100 but reduced padding
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // Reduced padding
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: borderColor),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: '+91',
                                          icon: Icon(Icons.keyboard_arrow_down, size: 20, color: textColor),
                                          isExpanded: true,
                                          dropdownColor: cardColor,
                                          style: GoogleFonts.lexend(fontSize: 14, color: textColor),
                                          items: ['+91'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                                                  const SizedBox(width: 4),
                                                  Text(value, style: GoogleFonts.lexend(fontSize: 14, color: textColor)),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (_) {},
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildTextField(
                                        controller: _phoneController,
                                        hint: '90000 00000',
                                        keyboardType: TextInputType.phone,
                                        isDark: isDark,
                                        backgroundColor: bgColor,
                                        textColor: textColor,
                                        hintColor: isDark ? Colors.white30 : Colors.grey,
                                        borderColor: borderColor,
                                        primaryColor: primaryColor,
                                        maxLength: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                
                                // PIN fields
                                _buildLabel('Create 4-digit PIN', textColor),
                                _buildTextField(
                                  controller: _passwordController,
                                  hint: 'Enter 4-digit PIN',
                                  icon: Icons.lock_outline,
                                  isDark: isDark,
                                  isPassword: true,
                                  // Enable numeric keyboard for PIN
                                  keyboardType: TextInputType.number,
                                  maxLength: 4, 
                                  backgroundColor: bgColor,
                                  textColor: textColor,
                                  hintColor: isDark ? Colors.white30 : Colors.grey,
                                  borderColor: borderColor,
                                  primaryColor: primaryColor,
                                ),
                                const SizedBox(height: 20),

                                _buildLabel('Confirm 4-digit PIN', textColor),
                                _buildTextField(
                                  controller: _confirmPasswordController,
                                  hint: 'Re-enter 4-digit PIN',
                                  icon: Icons.lock_outline,
                                  isDark: isDark,
                                  isPassword: true,
                                  // Enable numeric keyboard for PIN
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  backgroundColor: bgColor,
                                  textColor: textColor,
                                  hintColor: isDark ? Colors.white30 : Colors.grey,
                                  borderColor: borderColor,
                                  primaryColor: primaryColor,
                                ),

                                
                                const SizedBox(height: 24),
                                
                                // Continue Button
                                ElevatedButton(
                                  onPressed: _isLoading ? null : () async {
                                    final name = _nameController.text;
                                    final phone = '+91${_phoneController.text}'; // Hardcoded +91 for hackathon
                                    
                                    if (name.isEmpty || _phoneController.text.isEmpty || _passwordController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(TranslationService.tr('fill_all_fields'))));
                                      return;
                                    }

                                    // Validate phone number is exactly 10 digits
                                    if (_phoneController.text.length != 10) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone number must be exactly 10 digits')));
                                      return;
                                    }

                                    // Validate PIN is exactly 4 digits
                                    if (_passwordController.text.length != 4) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN must be exactly 4 digits')));
                                      return;
                                    }

                                    if (_passwordController.text != _confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(TranslationService.tr('password_mismatch'))));
                                      return;
                                    }

                                    setState(() => _isLoading = true);
                                    
                                    // Map code to language name
                                    String langName = 'English';
                                    if (locale.languageCode == 'hi') langName = 'Hindi';
                                    if (locale.languageCode == 'te') langName = 'Telugu';

                                    final success = await _authService.register(phone, name, langName, password: _passwordController.text);
                                    setState(() => _isLoading = false);

                                    if (success && mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => OtpVerificationScreen(phone: phone)),
                                      );
                                    } else if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Failed. Check connection.')));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: backgroundDark,
                                    elevation: 4,
                                    shadowColor: primaryColor.withOpacity(0.4),
                                    minimumSize: const Size(double.infinity, 60),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: _isLoading 
                                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            TranslationService.tr('continue_verify'),
                                            style: GoogleFonts.lexend(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.arrow_forward_rounded, size: 22),
                                        ],
                                      ),
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // Info Badge
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(isDark ? 0.1 : 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.verified_user_outlined, color: primaryColor, size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          TranslationService.tr('otp_msg'),
                                          style: GoogleFonts.lexend(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Log In Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${TranslationService.tr('already_account')} ", style: GoogleFonts.lexend(color: Colors.grey)),
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Text(
                                        TranslationService.tr('login'),
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
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                    
                    // Footer
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24, top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.spa, color: primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'EMPOWERING FARMERS',
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF8AB39A) : const Color(0xFF618971),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildLabel(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
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
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
    required Color backgroundColor,
    required Color textColor,
    required Color hintColor,
    required Color borderColor,
    required Color primaryColor,
    bool isPassword = false,
    int? maxLength,
  }) {
    bool obscureText = isPassword; 
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.lexend(fontSize: 16, color: textColor),
            keyboardType: keyboardType,
            maxLength: maxLength,
            decoration: InputDecoration(
              counterText: '',
              hintText: hint,
              hintStyle: GoogleFonts.lexend(color: hintColor),
              border: InputBorder.none,
              icon: icon != null ? Icon(icon, color: primaryColor) : null,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: hintColor,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    )
                  : null,
            ),
          ),
        );
      }
    );
  }



  // Helper helper method removed
}
