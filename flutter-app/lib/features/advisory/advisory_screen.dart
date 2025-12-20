import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/translation_service.dart';
import '../../services/weather_service.dart';
import '../home/home_screen.dart';
import '../guide/crop_guide_screen.dart';
import 'fertilizer_screen.dart';
import '../risk/risk_assessment_screen.dart';
import '../comparison/what_if_screen.dart';
import '../history/chat_history_screen.dart';
import '../market/marketplace_screen.dart';

class AdvisoryScreen extends StatefulWidget {
  const AdvisoryScreen({super.key});

  @override
  State<AdvisoryScreen> createState() => _AdvisoryScreenState();
}

class _AdvisoryScreenState extends State<AdvisoryScreen> {
  final WeatherService _weatherService = WeatherService('1051c574abd24624a12103408251912');
  List<dynamic> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherAlerts();
  }

  Future<void> _fetchWeatherAlerts() async {
    try {
      Position position = await _determinePosition();
      final forecastData = await _weatherService.getForecast(position.latitude, position.longitude);
      setState(() {
        _alerts = forecastData['alerts']?['alert'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
    final borderColor = theme.dividerColor.withOpacity(0.1);

    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
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
                    TranslationService.tr('advisory'),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Section: Intelligence Overview
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A3826), Color(0xFF102217)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome, color: primaryColor, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                TranslationService.tr('farm_intelligence'),
                                style: GoogleFonts.lexend(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isLoading ? "Loading intelligence..." : _alerts.isNotEmpty ? _alerts[0]['headline'] : "Your crops are looking healthy, but watch out for humidity levels.",
                            style: GoogleFonts.lexend(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Recent Alerts
                    Text(
                      TranslationService.tr('recent_alerts'),
                      style: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _alerts.isEmpty
                            ? const Text('No active alerts.')
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _alerts.map((alert) {
                                    return _buildAlertCard(
                                      context,
                                      icon: Icons.warning_amber,
                                      title: alert['event'] ?? 'Weather Alert',
                                      message: alert['desc'] ?? 'No details available.',
                                      color: Colors.orange,
                                      textColor: textColor,
                                      borderColor: borderColor,
                                    );
                                  }).toList(),
                                ),
                              ),
                    const SizedBox(height: 32),

                    // Tools Grid
                    Text(
                      TranslationService.tr('management_tools'),
                      style: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildEnhancedToolCard(
                          context,
                          title: TranslationService.tr('fertilizer'),
                          subtitle: 'Nutrient Guide',
                          icon: Icons.science,
                          gradientColors: [Colors.blue.shade900, Colors.blue.shade800],
                          iconColor: Colors.blue.shade200,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FertilizerScreen())),
                          textColor: textColor,
                          borderColor: borderColor,
                        ),
                        _buildEnhancedToolCard(
                          context,
                          title: TranslationService.tr('risk_scan'),
                          subtitle: 'Threat Analysis',
                          icon: Icons.shield,
                          gradientColors: [Colors.orange.shade900, Colors.orange.shade800],
                          iconColor: Colors.orange.shade200,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RiskAssessmentScreen())),
                          textColor: textColor,
                          borderColor: borderColor,
                        ),
                        _buildEnhancedToolCard(
                          context,
                          title: TranslationService.tr('what_if'),
                          subtitle: 'Scenario Planner',
                          icon: Icons.compare_arrows,
                          gradientColors: [Colors.purple.shade900, Colors.purple.shade800],
                          iconColor: Colors.purple.shade200,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WhatIfScreen())),
                          textColor: textColor,
                          borderColor: borderColor,
                        ),
                        _buildEnhancedToolCard(
                          context,
                          title: 'Pest Control',
                          subtitle: 'Coming Soon',
                          icon: Icons.pest_control,
                          gradientColors: [const Color(0xFF2A1010), const Color(0xFF200A0A)],
                          iconColor: Colors.red.shade200,
                          onTap: () {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pest Control module coming soon!")));
                          },
                          isLocked: true,
                          textColor: textColor,
                          borderColor: borderColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 80), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildAlertCard(BuildContext context, {required IconData icon, required String title, required String message, required Color color, required Color textColor, required Color borderColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF183222) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(message, style: GoogleFonts.lexend(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildEnhancedToolCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Color iconColor,
    required VoidCallback onTap,
    bool isLocked = false,
    required Color textColor,
    required Color borderColor,
  }) {
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors.map((c) => c.withOpacity(0.8)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                       Text(
                        subtitle,
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isLocked)
              Positioned(
                top: 12,
                right: 12,
                child: Icon(Icons.lock, color: Colors.white.withOpacity(0.2), size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
