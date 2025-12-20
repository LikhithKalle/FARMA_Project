import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../guide/crop_guide_screen.dart';
import '../advisory/advisory_screen.dart';
import '../profile/profile_screen.dart';
import '../history/chat_history_screen.dart';
import '../market/marketplace_screen.dart';

class WhatIfScreen extends StatelessWidget {
  const WhatIfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    const Color primaryColor = Color(0xFF13EC6A);
    const Color backgroundDark = Color(0xFF102217);
    const Color surfaceDark = Color(0xFF1A3324); // Matching design
    const Color surfaceLight = Color(0xFFFFFFFF);
    const Color textDark = Color(0xFF111814);
    
    // Check Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final Color bgColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final Color cardBg = isDark ? surfaceDark : surfaceLight;
    final Color borderColor = isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: bgColor,
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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[100],
                          ),
                          child: Icon(Icons.arrow_back, color: textColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Comparing Options',
                        style: GoogleFonts.lexend(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: cardBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          'EN',
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                             BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: const Icon(Icons.mic, color: Color(0xFF052E16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  
                  // Headline
                  Column(
                    children: [
                      Text(
                        'Maize vs. Sorghum',
                        style: GoogleFonts.lexend(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Based on your soil data & weather forecast',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // Comparison Grid
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1: Maize
                      Expanded(
                        child: Column(
                          children: [
                            // Image Card
                            AspectRatio(
                              aspectRatio: 0.8,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuB85MKd9tX8CUT6Fu4ABh_CjMzeB55zoJGBkN9-hC0H_-_s09p0ftp9Fp9qE5_F2TIxrFYdD5dYpvQq21ckAwGPnG9PkTFvhnEswUa6wGHkCsyXO0WkZtcL9pjHjYQXFCl2avK_oOU6FiXOTwcTwjZzT83KMw6cdx0hoRz77ESa5Zg5_-W1vIrEEeAh9ppk9TB9EWHMPJmng5rqD3R4ESMhGJISeRA_gneXo9GjJK7T45TKh8bH52fXUBjtfcaMjHSuyFRITtdRIdQ'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center,
                                      colors: [Colors.black87, Colors.transparent],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  alignment: Alignment.bottomLeft,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Maize',
                                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text('TOP CHOICE', style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Metrics
                            _buildMetricCard(
                              label: 'Suitability',
                              value: '92%',
                              subValue: '+Excellent Fit', 
                              subColor: primaryColor,
                              showCheck: true,
                              cardBg: cardBg,
                              borderColor: borderColor,
                              textColor: textColor,
                            ),
                            const SizedBox(height: 8),
                            _buildMetricCard(
                              label: 'Water Needs',
                              iconRow: const Row(children: [
                                Icon(Icons.water_drop, color: Colors.blue, size: 18),
                                Icon(Icons.water_drop, color: Colors.blue, size: 18),
                                Icon(Icons.water_drop, color: Colors.blue, size: 18),
                              ]),
                              subValue: 'High Requirement',
                              subColor: isDark ? Colors.grey[300]! : Colors.grey[700]!,
                              cardBg: cardBg,
                              borderColor: borderColor,
                              textColor: textColor,
                            ),
                            const SizedBox(height: 8),
                            _buildMetricCard(
                              label: 'Risk Level',
                              customContent: Row(children: [
                                Container(width: 10, height: 10, decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: primaryColor, blurRadius: 4)])),
                                const SizedBox(width: 8),
                                Text('Low', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                              ]),
                              subValue: 'Stable market price.',
                              subColor: Colors.grey,
                              cardBg: isDark ? surfaceDark : const Color(0xFFE8F5E9),
                              borderColor: isDark ? borderColor : primaryColor.withOpacity(0.2),
                              textColor: textColor,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: const Color(0xFF052E16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                minimumSize: const Size(double.infinity, 50),
                                elevation: 0,
                              ),
                              child: const Text('Select Maize', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 16),

                      // Column 2: Sorghum
                      Expanded(
                        child: Column(
                          children: [
                             // Image Card
                            AspectRatio(
                              aspectRatio: 0.8,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD5PtArkJdjkeWMb8I4En7MuY3v_vMuTHsyURm9emZ6wWoZzfNSh8OZRKMjNznv9r6z_DlT-t_zHoOHiLDwMjKZktMBLHKKIvZdBArxhf7uZmmPyoRUN6RW70aj4SyQspRUld4JHInrmS_6lQUkOeHbjNd0pGQ7brcrKkgPkdsc3Ne9Ja3SgUBqw0RiH2tMQelT3tArHlj6QTO5I18guwiecmBJm8PVffhs_CfpzmzFm0_VbTDBbOwAFhowjGVANwR28m9v34E_u9I'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center,
                                      colors: [Colors.black87, Colors.transparent],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  alignment: Alignment.bottomLeft,
                                  child: const Text(
                                    'Sorghum',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                             // Metrics
                            _buildMetricCard(
                              label: 'Suitability',
                              value: '85%',
                              subValue: '+Good Fit', 
                              subColor: primaryColor.withOpacity(0.8),
                              cardBg: cardBg,
                              borderColor: borderColor,
                              textColor: textColor,
                            ),
                            const SizedBox(height: 8),
                            _buildMetricCard(
                              label: 'Water Needs',
                              iconRow: Row(children: [
                                const Icon(Icons.water_drop, color: Colors.blue, size: 18),
                                Icon(Icons.water_drop, color: Colors.blue.withOpacity(0.3), size: 18),
                                Icon(Icons.water_drop, color: Colors.blue.withOpacity(0.3), size: 18),
                              ]),
                              subValue: 'Low Requirement',
                              subColor: isDark ? Colors.grey[300]! : Colors.grey[700]!,
                              cardBg: cardBg,
                              borderColor: borderColor,
                              textColor: textColor,
                            ),
                            const SizedBox(height: 8),
                            _buildMetricCard(
                              label: 'Risk Level',
                              customContent: Row(children: [
                                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                Text('Medium', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                              ]),
                              subValue: 'Pest vulnerability.',
                              subColor: Colors.grey,
                              cardBg: isDark ? surfaceDark : Colors.orange[50]!,
                              borderColor: isDark ? borderColor : Colors.orange[100]!,
                              textColor: textColor,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: textColor,
                                side: BorderSide(color: borderColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Select Sorghum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Explanation Button
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: borderColor),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.lightbulb, color: primaryColor),
                                const SizedBox(width: 8),
                                Text(
                                  'Why these results?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Voice Hint
                  Center(
                    child: Text(
                      'Tap the mic to ask: "Which one earns more?"',
                      style: GoogleFonts.lexend(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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

  Widget _buildMetricCard({
    required String label,
    String? value,
    String? subValue,
    Color? subColor,
    Widget? iconRow,
    Widget? customContent,
    bool showCheck = false,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          if (customContent != null) customContent,
          if (value != null)
             Row(
               crossAxisAlignment: CrossAxisAlignment.end,
               children: [
                 Text(value, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold, height: 1)),
                 if (showCheck) ...[
                   const SizedBox(width: 4),
                   const Icon(Icons.verified, color: Color(0xFF13EC6A), size: 20),
                 ]
               ],
             ),
          if (iconRow != null) iconRow,
          const SizedBox(height: 4),
          if (subValue != null)
            Text(subValue, style: TextStyle(color: subColor, fontSize: 11, fontWeight: FontWeight.bold)),
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
