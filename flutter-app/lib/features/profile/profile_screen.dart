import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/translation_service.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import '../guide/crop_guide_screen.dart';
import '../advisory/advisory_screen.dart';
import '../history/chat_history_screen.dart';
import '../market/marketplace_screen.dart';
import '../auth/login_screen.dart'; // For logout navigation
import '../shared/language_bottom_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State for toggles
  bool _voiceOutput = true;
  bool _notifications = false;
  String _userName = 'Rajesh Kumar';
  String _userPhone = '+91 98765 43210';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await AuthService.getUserName();
    final phone = await AuthService.getUserPhone();
    if (mounted) {
      setState(() {
        _userName = name;
        _userPhone = phone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors matching the design
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final containerColor = isDark ? const Color(0xFF183222) : Colors.white; // Keeping surfaceDark for dark mode cards
    final borderColor = theme.dividerColor.withOpacity(0.1);
    final dangerColor = const Color(0xFFFF5252);

    final surfaceDark = isDark ? const Color(0xFF183222) : Colors.white;

    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                          ),
                          child: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      Text(
                        TranslationService.tr('profile'),
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                           // Edit profile action
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                          ),
                          child: Icon(Icons.edit, color: isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Scroll Area
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // Bottom padding for FAB and Nav
                    children: [
                      // Profile Header
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: containerColor, width: 4),
                                  image: const DecorationImage(
                                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDo1xZWGUYOhJouAoaVwCl4ceHDHTW242QGi3-uAeOR6I4165fmNtnYPw5NqZsWAnWKc5lz7MGzxBbt-NWFVHTEWdeZVfrwItDHdoKbLCEaEqfHAe6uRudHgTSgSaWs4u6v4FUIx3xDbY1i6AgvUTryYN_36Nmxw1SNDLbCxrfoRcXDeHDG5FflCcgyqzcwGzCn2DmugfLMnd-pUHx5DYNJHCSc4B0s-uLKT-KVhG7SZkWGG8pyju9hdJ1RRF4kqCHBNVG5Gy1-EnU'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                    ],
                                  ),
                                  child: Icon(Icons.camera_alt, size: 18, color: isDark ? const Color(0xFF102217) : Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _userName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, size: 18, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Nashik, Maharashtra',
                                style: GoogleFonts.lexend(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),

                      // Personal Details Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: surfaceDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TranslationService.tr('personal_details').toUpperCase(),
                              style: GoogleFonts.lexend(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(Icons.call, TranslationService.tr('phone_number'), _userPhone, primaryColor, textColor),
                            Divider(color: borderColor, height: 32),
                            _buildDetailRow(Icons.landscape, TranslationService.tr('farm_size'), '5 Acres', primaryColor, textColor),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Settings Section
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 12),
                        child: Text(
                          TranslationService.tr('settings').toUpperCase(),
                          style: GoogleFonts.lexend(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: surfaceDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Column(
                          children: [
                            _buildSettingItem(
                              icon: Icons.translate,
                              title: TranslationService.tr('language_label'),
                              subtitle: 'Hindi (हिन्दी)',
                              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                              onTap: () => showLanguageBottomSheet(context),
                              iconColor: primaryColor,
                              textColor: textColor,
                            ),
                            Divider(color: borderColor, height: 1),
                            _buildSettingItem(
                              icon: Icons.volume_up,
                              title: TranslationService.tr('voice_output'),
                              iconColor: primaryColor,
                              textColor: textColor,
                              trailing: Switch(
                                value: _voiceOutput,
                                onChanged: (val) => setState(() => _voiceOutput = val),
                                activeColor: primaryColor,
                                activeTrackColor: primaryColor.withOpacity(0.3),
                              ),
                            ),
                            Divider(color: borderColor, height: 1),
                            _buildSettingItem(
                              icon: Icons.notifications,
                              title: TranslationService.tr('notifications'),
                              iconColor: primaryColor,
                              textColor: textColor,
                              trailing: Switch(
                                value: _notifications,
                                onChanged: (val) => setState(() => _notifications = val),
                                activeColor: primaryColor,
                                activeTrackColor: primaryColor.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Actions Section
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: containerColor,
                          foregroundColor: isDark ? Colors.white : Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: borderColor),
                          ),
                        ),
                        icon: Icon(Icons.help_outline, color: primaryColor),
                        label: Text(TranslationService.tr('help_support'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Logout logic
                          await AuthService().logout();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context, 
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: dangerColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: dangerColor.withOpacity(0.3)),
                          ),
                        ),
                        icon: Icon(Icons.logout, color: dangerColor),
                        label: Text(TranslationService.tr('logout'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'App Version 2.1.0',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Voice FAB
            Positioned(
              bottom: 90, // Above bottom nav
              right: 16,
              child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.mic, size: 32, color: isDark ? const Color(0xFF102217) : Colors.white),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomNav(context),

    );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color primaryColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
        Text(value, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color textColor,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }


}
