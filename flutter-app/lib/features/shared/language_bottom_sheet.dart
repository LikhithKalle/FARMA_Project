import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/translation_service.dart';

void showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => const LanguageBottomSheet(),
  );
}

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1A2C22) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111814);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationService.tr('lang_select'),
                style: GoogleFonts.lexend(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: textColor)),
            ],
          ),
          const SizedBox(height: 24),
          _buildLanguageOption(context, 'English', 'en', TranslationService.locale.value.languageCode == 'en', isDark),
          const SizedBox(height: 12),
          _buildLanguageOption(context, 'हिंदी (Hindi)', 'hi', TranslationService.locale.value.languageCode == 'hi', isDark),
          const SizedBox(height: 12),
          _buildLanguageOption(context, 'తెలుగు (Telugu)', 'te', TranslationService.locale.value.languageCode == 'te', isDark),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String name, String code, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        TranslationService.changeLocale(code);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF13EC6A).withOpacity(0.1) 
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF13EC6A) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF111814),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF13EC6A)),
          ],
        ),
      ),
    );
  }
}
