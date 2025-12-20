import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/weather_service.dart';
import '../../services/translation_service.dart';
import '../chat/assistant_chat_screen.dart';
import '../guide/crop_guide_screen.dart';
import '../advisory/advisory_screen.dart';
import '../market/marketplace_screen.dart';
import '../profile/profile_screen.dart';
import '../history/chat_history_screen.dart';
import '../shared/language_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final WeatherService _weatherService = WeatherService('1051c574abd24624a12103408251912');
  String _temperature = '--';
  String _weatherCondition = 'Loading...';
  List<dynamic> _alerts = [];
  
  // Banner carousel
  late PageController _pageController;
  int _currentBannerIndex = 0;
  
  // Banner items - Seeds & Fertilizers advertising
  final List<Map<String, String>> _bannerItems = [
    {
      'tag': 'SEEDS',
      'title': 'Premium Wheat Seeds',
      'subtitle': 'High yield variety for your farm',
      'image': 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=800&q=80&fm=webp',
    },
    {
      'tag': 'FERTILIZER',
      'title': 'Organic NPK Blend',
      'subtitle': 'Boost your crop growth naturally',
      'image': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800&q=80&fm=webp',
    },
    {
      'tag': 'SEEDS',
      'title': 'Hybrid Rice Seeds',
      'subtitle': 'Disease resistant, high quality',
      'image': 'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?w=800&q=80&fm=webp',
    },
    {
      'tag': 'FERTILIZER',
      'title': 'Bio-Organic Compost',
      'subtitle': 'Enrich your soil sustainably',
      'image': 'https://images.unsplash.com/photo-1592419044706-39796d40f98c?w=800&q=80&fm=webp',
    },
    {
      'tag': 'SEEDS',
      'title': 'Cotton Seeds Pro',
      'subtitle': 'Best quality fiber production',
      'image': 'https://images.unsplash.com/photo-1601001815894-4bb6c81416d7?w=800&q=80&fm=webp',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _pageController = PageController(viewportFraction: 0.95);
    _startAutoScroll();
    _fetchWeatherData();
  }
  
  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _currentBannerIndex = (_currentBannerIndex + 1) % _bannerItems.length;
        _pageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  Future<void> _fetchWeatherData() async {
    try {
      Position position = await _determinePosition();
      final forecastData = await _weatherService.getForecast(position.latitude, position.longitude);
      setState(() {
        _temperature = '${forecastData['current']['temp_c'].round()}°C';
        _weatherCondition = forecastData['current']['condition']['text'];
        _alerts = forecastData['alerts']?['alert'] ?? [];
      });
    } catch (e) {
      setState(() {
        _weatherCondition = 'Failed to get weather';
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    
    final Color primaryColor = theme.primaryColor;
    final Color backgroundLight = Colors.white; 
    final Color backgroundDark = const Color(0xFF102217);
    final Color textDark = const Color(0xFF111814);
    
    final Color bgColor = isDark ? backgroundDark : backgroundLight;
    final Color textColor = isDark ? Colors.white : textDark;
    final Color cardBg = isDark ? const Color(0xFF1A3826) : Colors.white;
    final Color borderColor = isDark ? Colors.white10 : Colors.grey.shade200;

    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        return Scaffold(
          backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.local_florist, color: primaryColor, size: 28),
                      ),
                      Row(
                        children: [
                           // Language Toggle
                          GestureDetector(
                            onTap: () => showLanguageBottomSheet(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1A3826) : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.language, size: 18, color: isDark ? Colors.grey[300] : Colors.grey[500]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'EN | HI | TE',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Profile Button (Moved from Bottom Nav)
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1A3826) : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: borderColor),
                              ),
                              child: Icon(Icons.person, size: 20, color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TranslationService.tr('good_morning'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.grey[400] : Colors.grey[500],
                            ),
                          ),
                          Text(
                            'Farmer John',
                            style: GoogleFonts.lexend(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.sunny, color: Colors.amber, size: 24),
                              const SizedBox(width: 4),
                              Text(
                                _temperature,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _weatherCondition,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.grey[400] : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Auto-scrolling Advertising Banner
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SizedBox(
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _bannerItems.length,
                    itemBuilder: (context, index) {
                      final item = _bannerItems[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                item['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) => Container(
                                  color: primaryColor.withOpacity(0.3),
                                  child: const Icon(Icons.image, size: 50, color: Colors.white54),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item['tag']!,
                                      style: GoogleFonts.lexend(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF102217),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['title']!,
                                    style: GoogleFonts.lexend(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['subtitle']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Page Indicator
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double page = 0;
                  try {
                    page = _pageController.page ?? 0;
                  } catch (e) {
                    page = 0;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_bannerItems.length, (index) {
                      final isActive = (page.round() == index);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? primaryColor : (isDark ? Colors.white24 : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

            // Bot Button Section - Fills remaining space with glass effect
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AssistantChatScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? Colors.white.withOpacity(0.08) 
                          : Colors.black.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isDark 
                            ? Colors.white.withOpacity(0.15) 
                            : Colors.grey.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text ABOVE the icon
                        Text(
                          TranslationService.tr('planting_today'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexend(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          TranslationService.tr('ask_advice'),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.grey[400] : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Chat Bot Icon
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulse Effect
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return Container(
                                    width: 95 + (_controller.value * 15),
                                    height: 95 + (_controller.value * 15),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor.withOpacity(0.2 * (1 - _controller.value)),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(Icons.face_retouching_natural, size: 46, color: Color(0xFF111814)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
      },
    );
  }
}
