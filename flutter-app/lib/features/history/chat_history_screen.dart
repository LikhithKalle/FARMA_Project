import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/translation_service.dart';
import '../home/home_screen.dart';
import '../guide/crop_guide_screen.dart';
import '../advisory/advisory_screen.dart';
import '../market/marketplace_screen.dart';
import '../chat/assistant_chat_screen.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final containerColor = isDark ? const Color(0xFF1c2e20) : Colors.white;
    final borderColor = theme.dividerColor.withOpacity(0.1);

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                      ),
                      child: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    TranslationService.tr('history'),
                    style: GoogleFonts.lexend(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHistoryItem(
                    context,
                    title: "Tomato Disease Analysis",
                    date: "Today, 10:30 AM",
                    preview: "The yellow spots indicate early blight...",
                    isActive: true,
                    textColor: textColor,
                    containerColor: containerColor,
                    borderColor: borderColor,
                  ),
                  _buildHistoryItem(
                    context,
                    title: "Fertilizer for Corn",
                    date: "Yesterday",
                    preview: "Recommended NPK 20-20-20 for better growth...",
                    isActive: false,
                    textColor: textColor,
                    containerColor: containerColor,
                    borderColor: borderColor,
                  ),
                   _buildHistoryItem(
                    context,
                    title: "Weather Inquiry",
                    date: "Dec 15",
                    preview: "Heavy rain expected next week. Prepare drainage...",
                    isActive: false,
                    textColor: textColor,
                    containerColor: containerColor,
                    borderColor: borderColor,
                  ),
                   _buildHistoryItem(
                    context,
                    title: "Pest Control - Cotton",
                    date: "Dec 10",
                    preview: "Use Neem oil spray every 3 days...",
                    isActive: false,
                    textColor: textColor,
                    containerColor: containerColor,
                    borderColor: borderColor,
                  ),
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

  Widget _buildHistoryItem(BuildContext context, {
    required String title,
    required String date,
    required String preview,
    required bool isActive,
    required Color textColor,
    required Color containerColor,
    required Color borderColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        // In a real app, pass the conversation ID here
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AssistantChatScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? const Color(0xFF13EC6A).withOpacity(0.5) : borderColor,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.green.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF13EC6A)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: GoogleFonts.lexend(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
                      Text(date, style: GoogleFonts.lexend(color: isDark ? Colors.grey : Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(preview, style: GoogleFonts.lexend(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(left: 8),
                height: 8, width: 8,
                decoration: const BoxDecoration(color: Color(0xFF13EC6A), shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}
