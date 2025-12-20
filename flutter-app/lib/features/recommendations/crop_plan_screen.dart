import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../advisory/fertilizer_screen.dart';
import '../comparison/what_if_screen.dart';
import '../risk/risk_assessment_screen.dart';
import '../home/home_screen.dart';
import '../guide/crop_guide_screen.dart';
import '../history/chat_history_screen.dart';
import '../advisory/advisory_screen.dart';
import '../market/marketplace_screen.dart';

class CropPlanScreen extends StatelessWidget {
  final Map<String, dynamic> cropData;

  const CropPlanScreen({super.key, required this.cropData});

  static const Color primaryColor = Color(0xFF13EC6A);
  static const Color backgroundDark = Color(0xFF102217);
  static const Color surfaceDark = Color(0xFF1A2C22);
  static const Color surfaceHighlight = Color(0xFF23392D);
  static const Color textDark = Color(0xFF111814);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final containerColor = isDark ? const Color(0xFF1A2C22) : Colors.white;
    final borderColor = theme.dividerColor.withOpacity(0.1);

    final cropName = cropData['cropName'] ?? 'Unknown Crop';
    final explanation = cropData['suitabilityExplanation'] ?? 'Good fit for your farm.';
    final confidence = (cropData['confidence'] ?? 0.95) * 100;
    final imageUrl = cropData['imageUrl'] ?? 'https://via.placeholder.com/400';
    final season = 'Season: ${cropData['season'] ?? 'Optimal'}'; 

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleBtn(Icons.arrow_back, onTap: () => Navigator.pop(context)),
                  Column(
                    children: [
                      Text(
                        'Crop Detail Plan',
                        style: GoogleFonts.lexend(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '${cropName.toUpperCase()} • $season',
                        style: GoogleFonts.lexend(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: primaryColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  _buildCircleBtn(Icons.more_vert, color: Colors.transparent, iconColor: textColor.withOpacity(0.54)),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Hero Image Card
                  Container(
                    height: 224,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [theme.scaffoldBackgroundColor, Colors.transparent],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified, size: 16, color: backgroundDark),
                                const SizedBox(width: 4),
                                Text(
                                  '${confidence.toInt()}% Match',
                                  style: GoogleFonts.lexend(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.scaffoldBackgroundColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cropName,
                                style: GoogleFonts.lexend(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Recommended Variety',
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // AI Audio Player (Static for now, but name customized)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.graphic_eq, color: primaryColor, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI ASSISTANT',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  'Explanation for $cropName',
                                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow, size: 18, color: backgroundDark),
                              const SizedBox(width: 4),
                              Text(
                                'PLAY',
                                style: GoogleFonts.lexend(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: theme.scaffoldBackgroundColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Why this fits
                  Row(
                    children: [
                      Icon(Icons.psychology, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Why this crop fits',
                        style: GoogleFonts.lexend(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        _buildFitReason(context, Icons.landscape, Colors.orange, 'Suitability', explanation, textColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(context,
                          icon: Icons.agriculture, 
                          trendIcon: Icons.trending_up, 
                          value: 'High', 
                          unit: 'YIELD POTENTIAL', 
                          subtext: 'Optimal for your area',
                          highlightColor: primaryColor,
                          textColor: textColor
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(context,
                          icon: Icons.water_drop, 
                          value: cropData['waterRequirement'] ?? 'Medium', 
                          unit: 'WATER NEED', 
                          subtext: 'Based on crop type', 
                          highlightColor: Colors.blue,
                          textColor: textColor
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Risk Assessment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shield, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Risk Assessment',
                            style: GoogleFonts.lexend(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: primaryColor.withOpacity(0.2)),
                        ),
                        child: Text((cropData['riskLevel'] ?? 'Unknown').toString().toUpperCase(), style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4, offset:const Offset(0,2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Risk Analysis based on your inputs:',
                          style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        _buildRiskItem(context, 'Risk Level', 'Calculated as ${cropData['riskLevel']}.', textColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tools Section Title
                  Row(
                    children: [
                      Icon(Icons.handyman, color: primaryColor), // Changed icon to represent tools
                      const SizedBox(width: 8),
                      Text(
                        'Analysis Tools',
                         style: GoogleFonts.lexend(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Tools List
                  Column(
                    children: [
                      // 1. Fertilizer Guidance (Suggestions)
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FertilizerScreen())),
                        child: _buildToolCard(context,
                          icon: Icons.science, 
                          iconColor: Colors.blue, 
                          title: 'Fertilizer Guidance', 
                          subtitle: 'Comparison of Organic vs NPK',
                          textColor: textColor,
                          containerColor: containerColor,
                          borderColor: borderColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // 2. What If Analysis
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WhatIfScreen())),
                        child: _buildToolCard(context,
                          icon: Icons.compare_arrows, 
                          iconColor: Colors.purple, 
                          title: 'What-If Comparison', 
                          subtitle: 'Compare Maize vs Sorghum',
                          textColor: textColor,
                          containerColor: containerColor,
                          borderColor: borderColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // 3. Risk Awareness (Placeholder for now, user mentioned it)
                      GestureDetector(
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (_) => const RiskAssessmentScreen()));
                        },
                        child: _buildToolCard(context,
                          icon: Icons.shield, 
                          iconColor: Colors.orange, 
                          title: 'Risk Awareness', 
                          subtitle: 'View market and pest risks',
                          textColor: textColor,
                          containerColor: containerColor,
                          borderColor: borderColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: theme.scaffoldBackgroundColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      shadowColor: primaryColor.withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save_alt),
                        const SizedBox(width: 8),
                        Text(
                          'Save Plan to Profile',
                          style: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'FARMA INTELLIGENT SYSTEM',
                        style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildCircleBtn(IconData icon, {VoidCallback? onTap, Color color = Colors.white, Color iconColor = Colors.black}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _buildFitReason(BuildContext context, IconData icon, Color iconColor, String title, String desc, Color textColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF23392D) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, {required IconData icon, IconData? trendIcon, required String value, required String unit, required String subtext, required Color highlightColor, required Color textColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceDark = isDark ? const Color(0xFF183222) : Colors.white;
    return Container(
      height: 128,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.grey[400]),
              if (trendIcon != null) Icon(trendIcon, color: highlightColor, size: 14),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                unit,
                style: TextStyle(color: highlightColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                subtext,
                style: TextStyle(color: Colors.grey[500], fontSize: 10, height: 1.1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskItem(BuildContext context, String title, String desc, Color textColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: primaryColor, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 12, height: 1.5),
              children: [
                TextSpan(text: '$title: ', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                TextSpan(text: desc),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolCard(BuildContext context, {
    required IconData icon, 
    required Color iconColor, 
    required String title, 
    required String subtitle,
    required Color textColor,
    required Color containerColor,
    required Color borderColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4, offset:const Offset(0,2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
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
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: isDark ? Colors.grey : Colors.grey[400]),
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
