import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../guide/crop_guide_screen.dart';
import '../advisory/advisory_screen.dart';
import '../profile/profile_screen.dart';
import '../history/chat_history_screen.dart';
import '../market/marketplace_screen.dart';

class RiskAssessmentScreen extends StatelessWidget {
  const RiskAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final containerColor = isDark ? const Color(0xFF1C2E24) : Colors.white;
    final borderColor = theme.dividerColor.withOpacity(0.1);
    final textSecondary = isDark ? const Color(0xFF8BA898) : Colors.grey[600];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Back Button could be added here if this is pushed from CropPlanScreen
                       GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                          ),
                          child: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Risk Assessment',
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic, color: Colors.black),
                  ),
                ],
              ),
            ),
            
            // Meta Text
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Last updated: Today, 8:00 AM',
                style: TextStyle(color: textSecondary, fontSize: 13),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Weather Risk Card (Low)
                  _buildRiskCard(
                    context,
                    title: 'Weather',
                    description: 'Good rain predicted for planting week. Soil moisture is optimal.',
                    riskLevel: 'LOW RISK',
                    riskColor: const Color(0xFFE8F5E9), // Light Green bg for badge
                    riskTextColor: const Color(0xFF1B5E20), // Dark green text
                    icon: Icons.water_drop,
                    iconBg: const Color(0xFF1B5E20).withOpacity(0.2),
                    iconColor: primaryColor,
                    textColor: textColor,
                    containerColor: containerColor,
                    borderColor: borderColor,
                    subTextColor: textSecondary!,
                  ),
                  
                  const SizedBox(height: 16),

                  // Pests Risk Card (Medium)
                  _buildRiskCard(
                    context,
                    title: 'Pests',
                    description: 'Small chance of Fall Armyworm nearby. Monitor young leaves closely.',
                    riskLevel: 'MEDIUM RISK',
                    riskColor: const Color(0xFFFFF8E1), // Light Amber bg
                    riskTextColor: const Color(0xFFF57F17), // Dark amber text
                    icon: Icons.pest_control,
                    iconBg: const Color(0xFFF57F17).withOpacity(0.1),
                    iconColor: Colors.amber,
                    textColor: textColor,
                    containerColor: containerColor,
                    borderColor: borderColor,
                    subTextColor: textSecondary!,
                  ),

                  const SizedBox(height: 16),

                  // Market Risk Card (Low)
                  _buildRiskCard(
                    context,
                    title: 'Market',
                    description: 'Maize prices are stable and expected to rise next season.',
                    riskLevel: 'LOW RISK',
                    riskColor: const Color(0xFFE8F5E9),
                    riskTextColor: const Color(0xFF1B5E20),
                    icon: Icons.storefront,
                    iconBg: const Color(0xFF1B5E20).withOpacity(0.2),
                    iconColor: primaryColor,
                    textColor: textColor,
                    containerColor: containerColor,
                    borderColor: borderColor,
                    subTextColor: textSecondary!,
                  ),

                  const SizedBox(height: 24),

                  // Detailed Advice Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                         // Could define another screen or expanding logic here
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connecting to advisor...")));
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isDark ? Colors.transparent : primaryColor,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: primaryColor, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: const Icon(Icons.support_agent, color: Colors.white),
                      label: Text(
                        'Get Detailed Advice',
                        style: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildRiskCard(
    BuildContext context, {
    required String title,
    required String description,
    required String riskLevel,
    required Color riskColor,
    required Color riskTextColor,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color textColor,
    required Color containerColor,
    required Color borderColor,
    required Color subTextColor,
  }) {
    // Dark mode overrides for card look
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.9), // Keeping badge bright for visibility or dimming appropriately
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    riskLevel,
                    style: TextStyle(
                      color: riskTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: iconColor, size: 36),
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
    final secondaryColor = isDark ? const Color(0xFF8BA898) : Colors.grey[600];
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) 
            Container(height: 6, width: 6, margin: const EdgeInsets.only(bottom: 2), decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color, blurRadius: 6)])),
          Icon(icon, color: isSelected ? color : secondaryColor, size: 26),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.lexend(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? color : secondaryColor)),
        ],
      ),
    );
  }
}
