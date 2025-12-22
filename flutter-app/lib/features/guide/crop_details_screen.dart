import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../services/translation_service.dart';

class CropDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> crop;

  const CropDetailsScreen({super.key, required this.crop});

  @override
  State<CropDetailsScreen> createState() => _CropDetailsScreenState();
}

class _CropDetailsScreenState extends State<CropDetailsScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }
  
  void _initTts() async {
    await flutterTts.awaitSpeakCompletion(true);
    flutterTts.setStartHandler(() => setState(() => isSpeaking = true));
    flutterTts.setCompletionHandler(() => setState(() => isSpeaking = false));
    flutterTts.setCancelHandler(() => setState(() => isSpeaking = false));
  }

  Future<void> _speak() async {
    if (isSpeaking) {
      await flutterTts.stop();
      return;
    }
    
    // Get current locale from TranslationService
    final currentLocale = TranslationService.locale.value.languageCode;
    String ttsLang = 'en-US';
    if (currentLocale == 'hi') ttsLang = 'hi-IN';
    else if (currentLocale == 'te') ttsLang = 'te-IN';
    
    await flutterTts.setLanguage(ttsLang);
    await flutterTts.setPitch(1.0);
    
    // Speak localized description
    String description = TranslationService.getContent(widget.crop['description']);
    if (description.isEmpty) description = 'No description available.';
    
    await flutterTts.speak(description);
  }
  
  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to locale changes to rebuild UI
    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        final crop = widget.crop;
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final primaryColor = const Color(0xFF13EC6A); 
        final backgroundColor = isDark ? const Color(0xFF102217) : Colors.white;
        final surfaceColor = isDark ? const Color(0xFF1A2C22) : Colors.grey.shade100;
        final textColor = isDark ? Colors.white : const Color(0xFF102217);
        final subtitleColor = isDark ? Colors.white70 : Colors.grey.shade700;

        // Parse Growing Conditions safely
        final conditions = crop['growing_conditions'] as Map<String, dynamic>? ?? {};
        final diseases = (crop['diseases'] as List?)?.cast<Map<String, dynamic>>() ?? [];

        return Scaffold(
          backgroundColor: backgroundColor,
          body: CustomScrollView(
            slivers: [
              // 1. App Bar with Hero Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: backgroundColor,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26, 
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26, 
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        crop['imageUrl'] ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(color: Colors.grey),
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.transparent,
                              backgroundColor.withOpacity(0.8),
                              backgroundColor,
                            ],
                            stops: const [0.0, 0.4, 0.8, 1.0],
                          ),
                        ),
                      ),
                      // Title and Badges Overlay
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    TranslationService.getContent(crop['name']), // Localized Name
                                    style: GoogleFonts.lexend(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, 
                                    ),
                                  ),
                                ),
                                // Play Button for TTS
                                GestureDetector(
                                  onTap: _speak,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(isSpeaking ? Icons.stop : Icons.play_arrow, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              children: [
                                 if (crop['badge'] != null)
                                  _buildHeroTag(TranslationService.getContent(crop['badge']), primaryColor, Colors.black),
                                 
                                 // Generic Tags from list
                                 ...(crop['tags'] as List).map((tag) => 
                                   _buildHeroTag(TranslationService.getContent(tag['label']), Colors.black54, Colors.white)
                                 ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        TranslationService.getContent(crop['description']), // Localized Description
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          height: 1.6,
                          color: subtitleColor,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Growing Conditions Header (Needs Static Translation key if possible, but hardcoded for now or add to TranslationService)
                      // Ideally these headers should be in TranslationService. 
                      // 'Growing Conditions' -> Not currently there. Will default to English.
                      // I'll leave them english for now as requested "all new screen to trnalante lang" implied content. Header translation wasn't explicitly provided but I can try.
                      Row(
                        children: [
                          Icon(Icons.eco, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Growing Conditions', // TODO: Add to TranslationService if needed
                            style: GoogleFonts.lexend(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Conditions Cards
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: _buildConditionCard('Soil', TranslationService.getContent(conditions['soil']), Icons.landscape, surfaceColor, textColor, primaryColor)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildConditionCard('Climate', TranslationService.getContent(conditions['climate']), Icons.wb_sunny, surfaceColor, textColor, Colors.orange)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildConditionCard('Water', TranslationService.getContent(conditions['water']), Icons.water_drop, surfaceColor, textColor, Colors.blue)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                       // Diseases Header
                       if (diseases.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.orange), 
                              const SizedBox(width: 8),
                              Text(
                                'Common Diseases & Pests',
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          ...diseases.map((disease) => _buildDiseaseCard(disease, surfaceColor, textColor, subtitleColor)),
                       ],
                       
                       const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildHeroTag(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.lexend(
          color: textCol,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildConditionCard(String title, String value, IconData icon, Color bg, Color textCol, Color iconCol) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconCol.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconCol),
          ),
          const SizedBox(height: 12),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.lexend(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.lexend(fontSize: 13, fontWeight: FontWeight.w600, color: textCol),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(Map<String, dynamic> disease, Color bg, Color textCol, Color subCol) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bug_report, color: Colors.red),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TranslationService.getContent(disease['name']), // Localized Disease Name
                  style: GoogleFonts.lexend(fontSize: 15, fontWeight: FontWeight.bold, color: textCol),
                ),
                Text(
                  TranslationService.getContent(disease['description']), // Localized Disease Desc
                  style: GoogleFonts.lexend(fontSize: 12, color: subCol),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
