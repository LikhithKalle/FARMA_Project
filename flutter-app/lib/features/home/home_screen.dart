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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _fetchWeatherData();
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

            // Main Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 24),
                  
                  // Central pulsing button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const AssistantChatScreen()));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Pulse Effect
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Container(
                                      width: 140 + (_controller.value * 20),
                                      height: 140 + (_controller.value * 20),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor.withOpacity(0.2 * (1 - _controller.value)),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  width: 128,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.4),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    // Changing to a "nice bot" icon as requested
                                    child: Icon(Icons.face_retouching_natural, size: 64, color: Color(0xFF111814)), 
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
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
                          const SizedBox(height: 8),
                          Text(
                            TranslationService.tr('ask_advice'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.grey[400] : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  if (_alerts.isNotEmpty)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: const DecorationImage(
                              image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuB4gc--_YmxGvIv8JJHGwrup8T8BEtcNPggY3RSPOph7UZXK44TywKIzRlqCNRJ7VWG3WkJK3rQaGGr-OY6g1iJFhdWGj4o_tLeHHEzaH40kMKwD-vbEzuDOsqMLNMy0d7cplh2Ioo9QhCRtLTMjoNvGubuTMeS4-feqbnEAnBR4y1RuG2HuTgLbnvJJvw3l3YF9bHW1LIZ2Ki8EqnhayWiGPAiK2D80jfGxONOzk99zEmn-730_Xtc6hK2VX0A7ni4aHOGTOC-2eE'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.warning, color: Colors.amber, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _alerts[0]['headline'] ?? 'Weather Alert',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _alerts[0]['desc'] ?? 'Check for more details.',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                  // Grid Layout
                  // 1. Continue Card (Full Width)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor),
                      boxShadow: isDark ? null : [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TranslationService.tr('continue'),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Corn planting depth',
                              style: GoogleFonts.lexend(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Last discussed 2 hours ago...',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[400] : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: isDark ? const Color(0xFF2A4D36) : Colors.grey.shade100,
                          child: Icon(Icons.arrow_forward, color: textColor),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      // 2. Crop Guide Card
                      Expanded(
                        child: Container(
                          height: 160,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark 
                                  ? [const Color(0xFF1A3826), const Color(0xFF102217)]
                                  : [const Color(0xFFE0FADD), Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: isDark ? null : Border.all(color: Colors.grey.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF2A4D36) : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.menu_book, color: Colors.green, size: 24),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    TranslationService.tr('crop_guide'),
                                    style: GoogleFonts.lexend(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    TranslationService.tr('best_practices'),
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
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 3. Advisory Card
                      Expanded(
                        child: Container(
                          height: 160,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark 
                                  ? [const Color(0xFF3D3118), const Color(0xFF102217)]
                                  : [const Color(0xFFFFF3DC), Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: isDark ? null : Border.all(color: Colors.grey.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF4D3E2A) : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.support_agent, color: Colors.orange, size: 24),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    TranslationService.tr('advisory'),
                                    style: GoogleFonts.lexend(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    TranslationService.tr('talk_experts'),
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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
}
