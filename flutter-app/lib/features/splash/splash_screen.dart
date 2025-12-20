import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../language/language_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the LanguageSelectionScreen after a delay
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LanguageSelectionScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Theme-aware colors
    final Color primaryColor = theme.primaryColor;
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color textDarkColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : const Color(0xFF102217));
    final Color textLightColor = isDark ? Colors.white60 : const Color(0xFF6B7280);
    final Color footerTextColor = isDark ? const Color(0xFF8AB39A) : const Color(0xFF618971);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background decorative gradients/blurs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.15),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  _buildLogo(isDark, primaryColor),
                  const SizedBox(height: 32),
                  Text(
                    'FARMA',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Farmers Agriculture Recommendation\nand Monitoring Assistant',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: textLightColor,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  _buildFooter(primaryColor, footerTextColor),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isDark, Color primaryColor) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        children: [
          Center(
            child: Transform.rotate(
              angle: 6 * 3.14159 / 180, // 6 degrees in radians
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), // 2.5rem
                  color: primaryColor.withOpacity(0.2),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A2E22) : Colors.white,
                borderRadius: BorderRadius.circular(40), // 2.5rem
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 24,
                    spreadRadius: 8,
                  )
                ],
                border: Border.all(color: primaryColor.withOpacity(0.1)),
              ),
              child: Center(
                child: Container(
                  width: 96, // w-24
                  height: 96, // h-24
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icon/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Color primaryColor, Color footerTextColor) {
    return Column(
      children: [
        SizedBox(
          width: 32, // w-8
          height: 32, // h-8
          child: CircularProgressIndicator(
            strokeWidth: 4, // border-4
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            backgroundColor: primaryColor.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa_outlined, color: primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              'EMPOWERING FARMERS',
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w600, // semibold
                color: footerTextColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
