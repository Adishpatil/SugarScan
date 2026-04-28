import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:google_fonts/google_fonts.dart";
import "screens/home_screen.dart";
import "services/language_service.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Light status bar for the warm light theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await Hive.initFlutter();
  await Hive.openBox("history");
  await Hive.openBox("journal");
  LanguageService().load();

  runApp(const SugarScanApp());
}

// ── App Colors — Warm, earthy, farmer-friendly light palette ──
class AppColors {
  // Backgrounds
  static const background = Color(0xFFF7F5EF);       // Warm off-white
  static const surface = Colors.white;
  static const surfaceLight = Color(0xFFF0EDE4);       // Soft beige
  static const surfaceBright = Color(0xFFE8E4DA);       // Slightly darker beige

  // Primary greens
  static const primary = Color(0xFF2E7D32);             // Rich green
  static const primaryLight = Color(0xFF4CAF50);         // Medium green
  static const primaryDark = Color(0xFF1B5E20);          // Deep green
  static const primarySurface = Color(0xFFE8F5E9);       // Very light green

  // Accents
  static const accent = Color(0xFF43A047);
  static const gold = Color(0xFFEDAA1F);
  static const warmBrown = Color(0xFF5D4037);

  // Text
  static const textPrimary = Color(0xFF2C2C2C);
  static const textSecondary = Color(0xFF666666);
  static const textMuted = Color(0xFF999999);

  // Functional
  static const error = Color(0xFFD32F2F);
  static const warning = Color(0xFFF57C00);
  static const divider = Color(0xFFE0DDD5);

  // Drawer
  static const drawerHeader = Color(0xFF1B5E20);
}

class SugarScanApp extends StatefulWidget {
  const SugarScanApp({super.key});
  @override
  State<SugarScanApp> createState() => _SugarScanAppState();
}

class _SugarScanAppState extends State<SugarScanApp> {
  @override
  void initState() {
    super.initState();
    LanguageService().addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SugarScan",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          shadowColor: AppColors.divider,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        cardTheme: CardTheme(
          color: AppColors.surface,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: AppColors.primary.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: GoogleFonts.poppins(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
