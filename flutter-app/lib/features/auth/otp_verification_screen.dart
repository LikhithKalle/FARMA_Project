import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../../services/auth_service.dart';
import '../../services/translation_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  const OtpVerificationScreen({super.key, required this.phone});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  // Re-using colors from our theme
  static const Color primaryColor = Color(0xFF13EC6A);
  static const Color backgroundLightColor = Color(0xFFF6F8F7);
  static const Color textDarkColor = Color(0xFF102217);
  static const Color textGrayColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Theme-aware colors
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textDarkColor = isDark ? Colors.white : const Color(0xFF102217);
    final textGrayColor = isDark ? Colors.white60 : const Color(0xFF6B7280);
    
    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textDarkColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildOtpForm(context),
                const SizedBox(height: 32),
                _buildResendLink(),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          TranslationService.tr('verify_phone_title'),
          style: GoogleFonts.lexend(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: textDarkColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${TranslationService.tr('verify_phone_subtitle')} ${widget.phone}',
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 16,
            color: textGrayColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          // In a real app, you might use a package for the OTP input fields.
          // For this mock, a simple text field will suffice.
          _buildTextField(
            controller: _otpController, 
            icon: Icons.pin_outlined, 
            hint: TranslationService.tr('enter_otp'), 
            keyboardType: TextInputType.number
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: textDarkColor,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: _isLoading ? null : () async {
              setState(() => _isLoading = true);
              final success = await _authService.verifyOtp(widget.phone, _otpController.text);
              setState(() => _isLoading = false);

              if (success && mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(TranslationService.tr('invalid_otp'))));
              }
            },
            child: _isLoading 
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: textDarkColor))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TranslationService.tr('verify_proceed'), style: GoogleFonts.lexend(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
            ),
        ],
      ),
    );
  }

  Widget _buildResendLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(TranslationService.tr('resend_code'), style: const TextStyle(color: textGrayColor)),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () { /* TODO: Implement resend OTP logic */ },
          child: Text(TranslationService.tr('resend_action'), style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildTextField({required IconData icon, required String hint, TextInputType? keyboardType, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.center, // Center the OTP input
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(letterSpacing: 0, fontSize: 16),
        prefixIcon: Icon(icon, color: textGrayColor, size: 22),
        filled: true,
        fillColor: backgroundLightColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: primaryColor, width: 2)),
      ),
    );
  }
}
