import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/translation_service.dart';
import 'home_screen.dart';
import '../guide/crop_guide_screen.dart';
import '../history/chat_history_screen.dart';
import '../advisory/advisory_screen.dart';
import '../market/marketplace_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    CropGuideScreen(),
    ChatHistoryScreen(),
    AdvisoryScreen(),
    MarketplaceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF0D1C13).withOpacity(0.95) : Colors.white;
    const primaryColor = Color(0xFF13EC6A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: navBg,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, TranslationService.tr('home'), 0, primaryColor),
            _buildNavItem(Icons.spa, TranslationService.tr('guide'), 1, primaryColor),
            _buildNavItem(Icons.history, TranslationService.tr('history'), 2, primaryColor),
            _buildNavItem(Icons.tips_and_updates, TranslationService.tr('advisory'), 3, primaryColor),
            _buildNavItem(Icons.store, TranslationService.tr('market'), 4, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, Color color) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) 
            Container(height: 6, width: 6, margin: const EdgeInsets.only(bottom: 2), decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color, blurRadius: 6)])),
          Icon(icon, color: isSelected ? color : (isDark ? Colors.grey : Colors.grey[400]), size: 26),
          const SizedBox(height: 2),
          Text(
            label, 
            style: GoogleFonts.lexend(
              fontSize: 10, 
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, 
              color: isSelected ? color : (isDark ? Colors.grey : Colors.grey[600])
            )
          ),
        ],
      ),
    );
  }
}
