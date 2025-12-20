import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/translation_service.dart';
import '../auth/login_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // No default selection - user must choose
  String _selectedLanguage = '';

  static const Color primaryColor = Color(0xFF13EC6A);
  static const Color backgroundDark = Color(0xFF102217);
  static const Color surfaceDark = Color(0xFF1A2E22);

  void _selectLanguage(String code) {
    setState(() {
      _selectedLanguage = code;
    });
    
    // Update global app language
    TranslationService.changeLocale(code);
    
    // Navigate to Login Screen immediately (or after short delay for effect)
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
         Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Theme-aware colors
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final surfaceColor = isDark ? const Color(0xFF1A2E22) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Elements
           Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  _buildLogo(isDark, primaryColor, surfaceColor),
                  const SizedBox(height: 48),
                  Text(
                    'Select Language',
                    style: GoogleFonts.lexend(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF102217),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your preferred language',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  _buildLanguageButton('English', 'English', Icons.translate, 'en', isDark, primaryColor, surfaceColor, backgroundColor),
                  const SizedBox(height: 16),
                  _buildLanguageButton('తెలుగు', 'Telugu', Icons.graphic_eq, 'te', isDark, primaryColor, surfaceColor, backgroundColor),
                  const SizedBox(height: 16),
                  _buildLanguageButton('हिन्दी', 'Hindi', Icons.graphic_eq, 'hi', isDark, primaryColor, surfaceColor, backgroundColor),
                  
                  const Spacer(),
                  _buildFooter(primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isDark, Color primaryColor, Color surfaceColor) {
    return Container(
      width: 80,
      height: 80,
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
    );
  }

  Widget _buildLanguageButton(String title, String subtitle, IconData icon, String code, bool isDark, Color primaryColor, Color surfaceColor, Color backgroundColor) {
    final isSelected = _selectedLanguage == code;
    final textColor = isDark ? Colors.white : const Color(0xFF102217);
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;
    final borderColor = isDark ? Colors.white10 : Colors.black12;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectLanguage(code),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: isSelected ? primaryColor : subtitleColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: primaryColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(Color primaryColor) {
    return Row(
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
    );
  }
}
