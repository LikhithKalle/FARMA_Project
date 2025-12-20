import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../recommendations/comparison_screen.dart'; 
import 'crop_plan_screen.dart'; // Restore Import
import 'package:flutter_tts/flutter_tts.dart';
import '../home/home_screen.dart';
import '../../services/translation_service.dart';
import '../guide/crop_guide_screen.dart';
import '../history/chat_history_screen.dart';
import '../advisory/advisory_screen.dart';
import '../market/marketplace_screen.dart';

class RecommendationResultScreen extends StatelessWidget {
  final List<dynamic>? recommendations;

  const RecommendationResultScreen({super.key, this.recommendations});

  // Colors matching the design
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
    
    // Fallback/Mock Data if none provided
    final displayData = recommendations ?? [
      {
         'cropName': 'Maize (Simulated)',
         'suitabilityExplanation': 'Fallback data: Generally good for many soils.',
         'waterRequirement': 'Medium',
         'riskLevel': 'Low'
      }
    ];

    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
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
                  _buildCircleBtn(context, Icons.arrow_back, onTap: () => Navigator.pop(context)),
                  Column(
                    children: [
                      Text(
                        TranslationService.tr('crop_rec_title'),
                        style: GoogleFonts.lexend(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        TranslationService.tr('ai_analysis_complete'),
                        style: GoogleFonts.lexend(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: primaryColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 48), // Balance
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Bot Summary
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40, height: 40,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor.withOpacity(0.2), width: 2),
                          image: const DecorationImage(
                            image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDFBYgrSlRDO9FVl7kRkhfdV0NzE9dkzbIBd4F0q4VvTRUNoUBsveTslfd0CK1IBZeaU1lloh8qvfCaJtuDJqRSQ5eeBCqKCec6jfsodmcMJIFS8YGNRq1uxKRZrPbUeHMQkUnyBPlmwAgfKKWTkDATcZu-WjsyDR0q4Dhz5teA00b7trNOJZiwKy9RKSreyXoeOgStZTlSaAP8hrL4jShpzpGnqcD6NT0yii99kTiOTnPsPNh3-R_dVFdPzK9Os49B0R4D4Lg-OAY'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: surfaceDark,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                  topLeft: Radius.circular(2),
                                ),
                              ),
                              child: Text(
                                TranslationService.tr('found_crops_msg').replaceAll('{}', displayData.length.toString()),
                                style: GoogleFonts.lexend(fontSize: 16, color: Colors.white, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Dynamic Cards
                  ...displayData.map((rec) {
                    final cropName = rec['cropName'] ?? 'Unknown Crop';
                    final explanation = rec['suitabilityExplanation'] ?? 'No explanation provided.';
                    final risk = rec['riskLevel'] ?? 'Medium';
                    final water = rec['waterRequirement'] ?? 'Medium';
                    final imageUrl = rec['imageUrl'] ?? 'https://via.placeholder.com/300?text=$cropName';
                    
                    return _buildCropCard(
                        context,
                        cropData: rec, // Pass the full object
                        title: cropName,
                        matchScore: 'High Match',
                        tag: risk == 'Low' ? 'Low Risk' : 'Risk: $risk',
                        tagColor: risk == 'Low' ? primaryColor : Colors.orange,
                        description: "$explanation\n(Water: $water)",
                        imageUrl: imageUrl, 
                        matchBgColor: primaryColor,
                        matchTextColor: backgroundDark,
                        textColor: textColor,
                        containerColor: containerColor,
                        borderColor: borderColor,
                      );
                  }),
                  
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24, top: 12),
                      child: Text(
                        TranslationService.tr('end_of_recs'),
                        style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildCropCard(
    BuildContext context, {
    required Map<String, dynamic> cropData,
    required String title,
    required String matchScore,
    required String tag,
    required Color tagColor,
    required String description,
    required String imageUrl,
    required Color matchBgColor,
    required Color matchTextColor,
    required Color textColor,
    required Color containerColor,
    required Color borderColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          Container(
            height: 176,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
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
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: matchBgColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      matchScore,
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: matchTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    TranslationService.tr('best_rec'),
                    style: GoogleFonts.lexend(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tag.toUpperCase(),
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: tagColor,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.verified, color: tagColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                           description,
                           style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[600], fontSize: 14, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to details
                    Navigator.push(
                      context, 
                       MaterialPageRoute(builder: (context) => CropPlanScreen(cropData: cropData)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RecommendationResultScreen.surfaceHighlight, // Use static constant or pass logic. Wait, surfaceHighlight is static.
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: borderColor),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        TranslationService.tr('view_plan'),
                        style: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
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

  Widget _buildCircleBtn(BuildContext context, IconData icon, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}
