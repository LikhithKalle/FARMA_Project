import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/translation_service.dart';
import '../home/home_screen.dart';
import '../advisory/advisory_screen.dart';
import '../profile/profile_screen.dart';
import '../history/chat_history_screen.dart';
import '../market/marketplace_screen.dart';
import 'crop_details_screen.dart';
import 'crop_data.dart';

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

  // Crop Data
  // Imported from crop_data.dart

  List<Map<String, dynamic>> get _filteredCrops {
    if (_selectedFilterIndex == 0) return allCropsData;
    
    String category = '';
    switch (_selectedFilterIndex) {
      case 1: category = 'grains'; break;
      case 2: category = 'vegetables'; break;
      case 3: category = 'fruits'; break;
      case 4: category = 'cash_crops'; break;
    }
    
    return allCropsData.where((crop) {
      final categories = crop['categories'] as List<String>;
      return categories.contains(category);
    }).toList();
  }

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
        final crops = _filteredCrops;
        final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      child: Column(
                        children: [
                          // Filter Chips
                          Container(
                            height: 50,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              children: [
                                _buildFilterChip(0, TranslationService.tr('all')),
                                _buildFilterChip(1, TranslationService.tr('grains')),
                                _buildFilterChip(2, TranslationService.tr('vegetables')),
                                _buildFilterChip(3, TranslationService.tr('fruits')),
                                _buildFilterChip(4, TranslationService.tr('cash_crops')),
                              ],
                            ),
                          ),
                          
                          // Grid of Crops
                          Expanded(
                            child: crops.isEmpty 
                            ? Center(
                                child: Text(
                                  'No crops found in this category.',
                                  style: GoogleFonts.lexend(color: Colors.grey),
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75, // Taller cards
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: crops.length,
                                itemBuilder: (context, index) {
                                  return _buildCropCard(crops[index], isDark);
                                },
                              ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(int index, String label) {
    bool isSelected = _selectedFilterIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: GoogleFonts.lexend(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.transparent,
        selectedColor: primaryColor,
        checkmarkColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? primaryColor : Colors.grey.shade800,
          ),
        ),
        onSelected: (bool selected) {
          setState(() {
            _selectedFilterIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCropCard(Map<String, dynamic> crop, bool isDark) {
    final tags = (crop['tags'] as List).cast<Map<String, dynamic>>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropDetailsScreen(crop: crop),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    crop['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                        child: const Icon(Icons.broken_image, color: Colors.white),
                      );
                    },
                  ),
                  // Badge
                  if (crop['badge'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: crop['badgeColor'] ?? Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        TranslationService.getContent(crop['badge']), // Localized Badge
                        style: GoogleFonts.lexend(
                          color: crop['badgeTextColor'] ?? Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TranslationService.getContent(crop['name']), // Localized Name
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Only show first 2 tags
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: tags.take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (tag['color'] as Color? ?? primaryColor).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: (tag['color'] as Color? ?? primaryColor).withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                tag['icon'] as IconData, 
                                size: 10, 
                                color: tag['color'] as Color? ?? primaryColor
                              ),
                              const SizedBox(width: 4),
                              Text(
                                TranslationService.getContent(tag['label']), // Localized Tag
                                style: GoogleFonts.lexend(
                                  fontSize: 9,
                                  color: isDark ? Colors.grey.shade300 : Colors.black87,
                                ),
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
      ),
    );
  }
}
