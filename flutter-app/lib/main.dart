import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/splash/splash_screen.dart';
import 'services/translation_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define theme colors from your HTML
  static const Color primaryColor = Color(0xFF13EC6A);
  static const Color backgroundLightColor = Colors.white; // Completely white as requested
  static const Color backgroundDarkColor = Color(0xFF102217);
  static const Color surfaceDarkColor = Color(0xFF1A2C22);

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = Theme.of(context).textTheme;

    // Light Theme
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLightColor,
      cardColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        background: backgroundLightColor,
        surface: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      textTheme: GoogleFonts.splineSansTextTheme(baseTextTheme).apply(bodyColor: Colors.black87, displayColor: Colors.black87),
      useMaterial3: true,
    );

    // Dark Theme
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDarkColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        background: backgroundDarkColor,
        surface: surfaceDarkColor, // Use surface-dark for cards/containers
      ),
      textTheme: GoogleFonts.splineSansTextTheme(baseTextTheme).apply(bodyColor: Colors.white),
      useMaterial3: true,
    );

    return ValueListenableBuilder<Locale>(
      valueListenable: TranslationService.locale,
      builder: (context, locale, child) {
        return MaterialApp(
          title: 'FARMA',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system, 
          locale: locale,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
