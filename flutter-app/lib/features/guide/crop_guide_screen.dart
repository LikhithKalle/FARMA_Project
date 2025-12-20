import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/translation_service.dart';
import '../home/home_screen.dart';
import '../advisory/advisory_screen.dart';
import '../profile/profile_screen.dart';
import '../history/chat_history_screen.dart';
import '../market/marketplace_screen.dart';

class CropGuideScreen extends StatefulWidget {
  const CropGuideScreen({super.key});

  @override
  State<CropGuideScreen> createState() => _CropGuideScreenState();
}

class _CropGuideScreenState extends State<CropGuideScreen> {
  static const Color primaryColor = Color(0xFF13EC6A);
  static const Color backgroundDark = Color(0xFF102217);
  static const Color surfaceDark = Color(0xFF1A2C22);
  
  // Filter state
  int _selectedFilterIndex = 0;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : const Color(0xFF102217);
    final surfaceColor = isDark ? const Color(0xFF1A2C22) : Colors.white;
    
    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        final List<Map<String, dynamic>> filters = [
          {'icon': Icons.grid_view, 'label': TranslationService.tr('all')},
          {'icon': Icons.grass, 'label': TranslationService.tr('grains')},
          {'icon': Icons.local_restaurant, 'label': TranslationService.tr('vegetables')},
          {'icon': Icons.local_florist, 'label': TranslationService.tr('fruits')},
          {'icon': Icons.attach_money, 'label': TranslationService.tr('cash_crops')},
        ];

        return Scaffold(
          backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        TranslationService.tr('crop_guide'),
                        style: GoogleFonts.lexend(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.notifications, color: textColor, size: 24),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Search Bar
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText: TranslationService.tr('search_crops'),
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              width: 48, height: 48,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.mic, color: Colors.black),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tip/Prompt
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: primaryColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.tips_and_updates, color: primaryColor, size: 20),
                            const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  TranslationService.tr('crop_tip'),
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(filters.length, (index) {
                            final isSelected = index == _selectedFilterIndex;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedFilterIndex = index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? primaryColor : surfaceColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isSelected ? primaryColor : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade300)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      filters[index]['icon'] as IconData,
                                      size: 18,
                                      color: isSelected ? Colors.black : (isDark ? Colors.grey[300] : Colors.grey[700]),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      filters[index]['label'] as String,
                                      style: GoogleFonts.lexend(
                                        color: isSelected ? Colors.black : (isDark ? Colors.grey[300] : Colors.grey[700]),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                        children: [
                          _buildCropCard(
                            name: 'Maize',
                            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA5MExohcO7M8Ed4KfsIQsxCnebIsAV6H2EsvUQFuieIT2OxYGtbAcObb3j5iNvMtPWP4feQsLgyh-f5oA2HMbHEF-ZNnurnSva5x3tPxpr3KbXHAhaNlZJMOAQy8BbpPHx_sY73zPORloJ0XwKgu8nKS4knl2ZDrZzRVeQO3TEgdWDH3wo1XuMxsTkKU1LrkwzMygdOie-cO0Sde2R4ABYPNVwgGC7OBtbxNgaRct3kVjNQylBRJT0WZ8Y0To_k_GLYJNXMhGlxGk',
                            badge: 'High Value',
                            tags: [
                              {'icon': Icons.water_drop, 'label': 'Moderate'},
                              {'icon': Icons.calendar_month, 'label': '90 Days'},
                            ],
                          ),
                          _buildCropCard(
                            name: 'Tomato',
                            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAFUKzGUzL8PzBfZdoQRKXVCWuMM07U7NO8qkaP3SGN9ZcLjvq7ZQeReIRN97NEgMl3-rLTZiAQ7LSDmcZQQBBKjRi7Mh3iSjdwANSFxptU6ki9s7rUJr4_xO6sRoagBjxs6xwXrv9k4R226LtlMhJyC2ww4UvfOrr8GNKI6j10FagteUPdRVxBEPhBeLSBmeQXVHVOwxA-fqDmKRFHA5kPfYuX3-018_y9_69PvpxFZQhrm21vyVVBe52nOPzLchU6VKrvbfFWwOE',
                            
                            tags: [
                              {'icon': Icons.water_drop, 'label': 'High Water', 'color': Colors.blue},
                              {'icon': Icons.monetization_on, 'label': 'Cash Crop'},
                            ],
                          ),
                          _buildCropCard(
                            name: 'Sorghum',
                            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB-_HdpgXH0bTDYI10S15hyhl06hUnyMyz-KH95AdP3riAu1wKDkZdYMDNWPf-zIrm28IlmE9i1QHJmi6DqjsZ4ebKF7M1C72ykZlqlxRyvWS3d-5VOGTR_TBDCLZRUOWE1JIKvlNbu2jU-ruAfkpp0n8XCTBsDLM2zCdNLXWXSmuRrwHOuPZ1CRrmVlMSWieEwUujIxk27g4RLPSffvR1ThOPqnUBZdfDoPghta05USo4ZxMbmz0c5iBduk7g3mI9ynqAXK_uJKBM',
                            badge: 'Recommended',
                            badgeColor: primaryColor,
                            badgeTextColor: Colors.black,
                            tags: [
                              {'icon': Icons.wb_sunny, 'label': 'Drought Res', 'color': Colors.amber},
                            ],
                          ),
                          _buildCropCard(
                            name: 'Cassava',
                            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA40BP4Wtlb9RjOKbgBDg-b7ghrPbImCJr3SAROwnunVObl1UQigw9u38ZyJjxUHkxrnstKCeKaopNXUEAVXxfLhDjy7pUeLUn7I846I-mt2UmQOhUsfPkA7SH2_ivlshardZcM_vuAAtPYNiSBeCcZaWHTtqyyM7PsjJvGHU8NYZYG29FAD83ffKemoOWOXER7vVLciGPFS48WHKHzLjjt5L3uafHwEj1eQhFtHBuwtFDTp1Z4nmP87JxBhcGo6IuEYUG5CUBpSIY',
                            tags: [
                              {'icon': Icons.shield, 'label': 'Resilient'},
                              {'icon': Icons.build, 'label': 'Easy Care'},
                            ],
                          ),
                           _buildCropCard(
                            name: 'Coffee',
                            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC7kr6Zq6l0p6Vz7ucLQKIepjrKlnkIl8-d_jVfNxn-98PD_2w4E292FvYLYMSvAjrOWzg8ZSlMm3VhvKpce9_4trXt57M9ZhSvAhKoyBF7ZBipwu_oW8fLOQ_Mn7NAHagtiunsAMypPiaQQTgqy9AQr4_7W_KSfys52wLHkOTehLDIoldO8ich69Ci7S5xkMLVRZsbg2ZT9L4JeL1b8zJdGEWqX9GXxx03EdE_8iEw-Shy7_JDlzdeVZDQz9Ml_8Z4IFkWr6Qs2zE',
                            tags: [
                              {'icon': Icons.landscape, 'label': 'Highland'},
                              {'icon': Icons.attach_money, 'label': 'Export'},
                            ],
                          ),
                          _buildCropCard(
                            name: 'Apples',
                            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCBzU00Pa5_c0iMPsaTH3WSQELLl0Ix2aYgqbynOp9sUQSSQaETnxriVjPqKui0tpmGfx30WpID3DMXu_upO6zqoQmW0bOn_vUXeojtYNOFtFecAF8pDM-UpUjLqJ3wgCX7XV8k1fXosNkK1CFsmS0cixuxzDgEP8zCZ_1kEz4Hf8zOsI-9U6qc5gVuwtTZwG42HuI_PRyW1AuSEcD2AUs4882zrf9LEl3JxB6hW3azYwHi_qt5eTXCaXwsGXR-5xd5bmjy95jDZt0',
                            tags: [
                              {'icon': Icons.ac_unit, 'label': 'Cold Climate'},
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),

            // Floating Mic Button
            Positioned(
              bottom: 100,
              right: 16,
              child: Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 8)),
                  ],
                ),
                child: const Icon(Icons.mic, size: 32, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildCropCard({
    required String name,
    required String imageUrl,
    String? badge,
    Color badgeColor = Colors.black54, // Default to translucent black
    Color badgeTextColor = const Color(0xFF13EC6A), // Default text color
    required List<Map<String, dynamic>> tags,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade300),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                if (badge != null)
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badge == 'High Value' ? Colors.black.withOpacity(0.6) : badgeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: badge == 'High Value' ? primaryColor : badgeTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF102217),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(tag['icon'] as IconData, size: 10, color: tag['color'] as Color? ?? Colors.grey),
                            const SizedBox(width: 2),
                            Text(
                              tag['label'] as String,
                              style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey : Colors.grey.shade700, fontSize: 9),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

}
}
