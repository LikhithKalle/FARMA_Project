import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../guide/crop_guide_screen.dart';
import 'advisory_screen.dart';
import '../profile/profile_screen.dart';
import '../history/chat_history_screen.dart';
import '../market/marketplace_screen.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  // Hardcoded colors removed in favor of theme extraction


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final containerColor = isDark ? const Color(0xFF1C2C23) : Colors.white;
    final borderColor = theme.dividerColor.withOpacity(0.1);
    final textSecondary = isDark ? const Color(0xFF9DB9A8) : Colors.grey[600];
    final surfaceHighlight = isDark ? const Color(0xFF25382E) : Colors.grey[100]!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                   GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87, size: 24),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Fertilizer Guidance',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer for balance
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 8),
                  
                  // Media Player Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.record_voice_over, color: primaryColor, size: 20),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Advisor: Fertilizer Basics',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap to listen to the explanation',
                                    style: TextStyle(color: textSecondary, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.play_arrow, color: isDark ? const Color(0xFF102217) : Colors.white, size: 32),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Progress Bar
                        Row(
                          children: [
                            Text('0:00', style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60, // Mock progress
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('2:45', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section Headline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Compare Types',
                        style: GoogleFonts.lexend(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Icon(Icons.compare_arrows, color: isDark ? Colors.grey : Colors.grey[600]),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Organic Card
                  _buildComparisonCard(
                    title: 'Organic Fertilizer',
                    desc: 'Manure & Compost. Makes soil stronger over time. Safe for all crops and very cheap.',
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA9orQormX4bCwNplyeHf_oPdGMtWZkQ4Jd2ThKcx2MQbSMSH0D5L0Y72VhsDVs4EJXBS5PDzWZ8TFuApItdq-ZJxvIRsBShsQSHwQPfJFvyWEeaP1iqWcFP2Q6dbLRWcYy4JXEI1Bhjzlt36Bdoduu55wxHZEPGqpyU0Xal3z1eUyKQE07o4fHZwZlF4UgLIZKStNJI-4-c7VD48mVE9L6Cp6Xn1jhbutXkikSihQaQx4RJj0nIf_fFv3JDkMMgbXPK8S3v2_PkhI',
                    icon: Icons.eco,
                    iconColor: primaryColor,
                    tags: [
                      {'icon': Icons.hourglass_top, 'label': 'Slow Release', 'color': primaryColor},
                      {'icon': Icons.spa, 'label': 'Soil Friendly', 'color': primaryColor},
                    ],
                  ),

                  const SizedBox(height: 24),

                  // NPK Card
                  _buildComparisonCard(
                    title: 'NPK (Chemical)',
                    desc: 'Granules or liquid. Makes crops grow very fast. Needs careful measuring to avoid burning plants.',
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBhMWDBF8x7PHUubuj3u0r8WLMJNT5g184eohyKdK3wZF-eSkfE89k6JJE7AOL7GnwKuELJpSrO1qpouoZVar9IqAhoftV7-AeyJSQANgYlEa7DLdXOgWtlPq4aoFvev8Qb8_THthMccunPPPc6MsF4_0Yphz5xUBtNiRNYmbFv8RA9t4VJVt_UuZFaUCsRT2Hc4kjzqtY13kOaD7i8KdXJiXx9ETX6Afc2uaj5B2fABdO1SOdcvGBDwk3UzOPJxGoMvmdooM1iVlg',
                    icon: Icons.science,
                    iconColor: Colors.blue[400]!,
                    tags: [
                      {'icon': Icons.speed, 'label': 'Fast Action', 'color': Colors.blue[400]},
                      {'icon': Icons.warning, 'label': 'Use with Caution', 'color': Colors.amber[400]},
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Replay Action
                  Center(
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.replay, color: primaryColor),
                      label: Text(
                        'Replay Advice',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required String desc,
    required String imageUrl,
    required IconData icon,
    required Color iconColor,
    required List<Map<String, dynamic>> tags,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF1C2C23) : Colors.white;
    final borderColor = theme.dividerColor.withOpacity(0.1);
    final textSecondary = isDark ? const Color(0xFF9DB9A8) : Colors.grey[600];
    final surfaceHighlight = isDark ? const Color(0xFF25382E) : Colors.grey[100]!;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : [const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Image Header
          SizedBox(
            height: 192,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [containerColor, Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          // backdropFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Requires dart:ui
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                // Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) {
                    final color = tag['color'] as Color;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: surfaceHighlight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(tag['icon'] as IconData, size: 16, color: color),
                          const SizedBox(width: 6),
                          Text(
                            tag['label'] as String,
                            style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF0D1C13).withOpacity(0.9) : Colors.white;
    const primaryColor = Color(0xFF13EC6A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: navBg,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(context, Icons.home, 'Home', false, primaryColor, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()))),
          _buildNavItem(context, Icons.spa, 'Guide', false, primaryColor, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CropGuideScreen()))),
          _buildNavItem(context, Icons.history, 'History', false, primaryColor, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatHistoryScreen()))),
          _buildNavItem(context, Icons.tips_and_updates, 'Advisory', true, primaryColor, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdvisoryScreen()))),
          _buildNavItem(context, Icons.store, 'Market', false, primaryColor, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen()))),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isSelected, Color color, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) 
            Container(height: 6, width: 6, margin: const EdgeInsets.only(bottom: 2), decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color, blurRadius: 6)])),
          Icon(icon, color: isSelected ? color : (isDark ? Colors.grey : Colors.grey[400]), size: 26),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.lexend(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? color : (isDark ? Colors.grey : Colors.grey[600]))),
        ],
      ),
    );
  }
}
