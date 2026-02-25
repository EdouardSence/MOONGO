import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// 🌿 MOONGO ENCHANTED FOREST THEME
/// ═══════════════════════════════════════════════════════════════════════════
///
/// A distinctive "Enchanted Forest Whimsy" aesthetic featuring:
/// - Deep moss greens and warm amber accents
/// - Organic gradients inspired by twilight forests
/// - Playful typography with Fraunces display + DM Sans body
/// - Dramatic shadows and soft glows for depth
/// - Nature-inspired textures and forms
///
/// Color Philosophy:
/// - Primary: Deep Forest Moss (#2D5A47) - grounded, natural authority
/// - Secondary: Warm Amber (#D4A574) - inviting glow, reward feeling
/// - Accent: Mystic Plum (#7C3AED) - magical touches, rare items
/// - Tertiary: Golden Honey (#F59E0B) - success, seeds, achievements
/// ═══════════════════════════════════════════════════════════════════════════

class AppColors {
  // ═══════════════════════════════════════════════════════════════════════════
  // 🎨 CORE PALETTE - Enchanted Forest
  // ═══════════════════════════════════════════════════════════════════════════

  /// Deep forest moss - Primary brand color
  static const Color primary = Color(0xFF2D5A47);

  /// Warm amber glow - Secondary accent
  static const Color secondary = Color(0xFFD4A574);

  /// Mystic plum - Magical accent for special elements
  static const Color accent = Color(0xFF7C3AED);

  /// Golden honey - Success, seeds, achievements
  static const Color tertiary = Color(0xFFF59E0B);

  /// Rich burgundy - For emphasis and warnings
  static const Color burgundy = Color(0xFF9F1239);

  // ═══════════════════════════════════════════════════════════════════════════
  // ☀️ LIGHT MODE - Morning Forest
  // ═══════════════════════════════════════════════════════════════════════════

  /// Warm cream canvas
  static const Color lightBackground = Color(0xFFFAF7F2);

  /// Soft parchment surface
  static const Color lightSurface = Color(0xFFFFFDF8);

  /// Cream cards with warmth
  static const Color lightCard = Color(0xFFFFFDF8);

  /// Misty morning meadow
  static const Color lightHomeBackground = Color(0xFFF0F7F4);

  /// Light text colors
  static const Color lightTextPrimary = Color(0xFF1A2F23);
  static const Color lightTextSecondary = Color(0xFF4A6355);

  // ═══════════════════════════════════════════════════════════════════════════
  // 🌙 DARK MODE - Twilight Forest
  // ═══════════════════════════════════════════════════════════════════════════

  /// Deep twilight canvas
  static const Color darkBackground = Color(0xFF0F1A14);

  /// Mossy darkness
  static const Color darkSurface = Color(0xFF1A2F23);

  /// Forest shadow cards
  static const Color darkCard = Color(0xFF1F3829);

  /// Enchanted night meadow
  static const Color darkHomeBackground = Color(0xFF0D1710);

  /// Dark text colors
  static const Color darkTextPrimary = Color(0xFFF0F7F4);
  static const Color darkTextSecondary = Color(0xFFB8CDBF);

  // ═══════════════════════════════════════════════════════════════════════════
  // 🏞️ LANDSCAPE GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Morning forest gradient (bottom to top: grass → sky → dawn)
  static const List<Color> lightLandscapeGradient = [
    Color(0xFF8BC4A8), // Soft sage green
    Color(0xFFB8E0D2), // Misty mint
    Color(0xFFE8D5C4), // Dawn blush
    Color(0xFFFAE8D4), // Golden horizon
  ];

  /// Twilight forest gradient (bottom to top: deep moss → purple dusk)
  static const List<Color> darkLandscapeGradient = [
    Color(0xFF1F3829), // Deep moss
    Color(0xFF2A4A3A), // Forest shadow
    Color(0xFF2D3A4A), // Twilight blue
    Color(0xFF3A2D4A), // Mystic purple
  ];

  /// Morning grass with dew
  static const Color lightGrass = Color(0xFF6B9B7A);

  /// Twilight moss
  static const Color darkGrass = Color(0xFF3D6B52);

  // ═══════════════════════════════════════════════════════════════════════════
  // 📝 TASK CARD COLORS (replacing post-it with organic paper look)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Aged parchment
  static const Color lightTaskCard = Color(0xFFFFF8E7);

  /// Warm oak border
  static const Color lightTaskBorder = Color(0xFFD4A574);

  /// Ink on parchment
  static const Color lightTaskText = Color(0xFF5C4033);

  /// Moonlit parchment
  static const Color darkTaskCard = Color(0xFF2A2318);

  /// Amber glow border
  static const Color darkTaskBorder = Color(0xFF8B6914);

  /// Golden ink
  static const Color darkTaskText = Color(0xFFD4B896);

  // ═══════════════════════════════════════════════════════════════════════════
  // ✨ SPECIAL EFFECTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Glow colors for magical effects
  static const Color goldenGlow = Color(0x40F59E0B);
  static const Color mysticGlow = Color(0x407C3AED);
  static const Color forestGlow = Color(0x402D5A47);

  /// Shadow colors
  static const Color lightShadow = Color(0x1A2D5A47);
  static const Color darkShadow = Color(0x40000000);
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎭 THEME EXTENSION
/// ═══════════════════════════════════════════════════════════════════════════

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color homeBackground;
  final List<Color> landscapeGradient;
  final Color grassColor;
  final Color postItBackground;
  final Color postItBorder;
  final Color postItText;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color glowColor;
  final Color shadowColor;

  const AppThemeExtension({
    required this.homeBackground,
    required this.landscapeGradient,
    required this.grassColor,
    required this.postItBackground,
    required this.postItBorder,
    required this.postItText,
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.glowColor,
    required this.shadowColor,
  });

  static const light = AppThemeExtension(
    homeBackground: AppColors.lightHomeBackground,
    landscapeGradient: AppColors.lightLandscapeGradient,
    grassColor: AppColors.lightGrass,
    postItBackground: AppColors.lightTaskCard,
    postItBorder: AppColors.lightTaskBorder,
    postItText: AppColors.lightTaskText,
    cardBackground: AppColors.lightCard,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    glowColor: AppColors.goldenGlow,
    shadowColor: AppColors.lightShadow,
  );

  static const dark = AppThemeExtension(
    homeBackground: AppColors.darkHomeBackground,
    landscapeGradient: AppColors.darkLandscapeGradient,
    grassColor: AppColors.darkGrass,
    postItBackground: AppColors.darkTaskCard,
    postItBorder: AppColors.darkTaskBorder,
    postItText: AppColors.darkTaskText,
    cardBackground: AppColors.darkCard,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    glowColor: AppColors.mysticGlow,
    shadowColor: AppColors.darkShadow,
  );

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? homeBackground,
    List<Color>? landscapeGradient,
    Color? grassColor,
    Color? postItBackground,
    Color? postItBorder,
    Color? postItText,
    Color? cardBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? glowColor,
    Color? shadowColor,
  }) {
    return AppThemeExtension(
      homeBackground: homeBackground ?? this.homeBackground,
      landscapeGradient: landscapeGradient ?? this.landscapeGradient,
      grassColor: grassColor ?? this.grassColor,
      postItBackground: postItBackground ?? this.postItBackground,
      postItBorder: postItBorder ?? this.postItBorder,
      postItText: postItText ?? this.postItText,
      cardBackground: cardBackground ?? this.cardBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      glowColor: glowColor ?? this.glowColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      homeBackground: Color.lerp(homeBackground, other.homeBackground, t)!,
      landscapeGradient: [
        for (int i = 0; i < landscapeGradient.length; i++)
          Color.lerp(landscapeGradient[i], other.landscapeGradient[i], t)!,
      ],
      grassColor: Color.lerp(grassColor, other.grassColor, t)!,
      postItBackground:
          Color.lerp(postItBackground, other.postItBackground, t)!,
      postItBorder: Color.lerp(postItBorder, other.postItBorder, t)!,
      postItText: Color.lerp(postItText, other.postItText, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }
}

/// Extension pratique pour accéder à AppThemeExtension
extension ThemeDataExtension on ThemeData {
  AppThemeExtension get appTheme =>
      extension<AppThemeExtension>() ?? AppThemeExtension.light;
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎨 TYPOGRAPHY STYLES
/// ═══════════════════════════════════════════════════════════════════════════

class AppTypography {
  /// Display font: Fraunces - Organic, expressive, memorable
  static TextStyle displayFont({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return GoogleFonts.fraunces(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: -0.5,
    );
  }

  /// Body font: DM Sans - Clean, modern, highly readable
  static TextStyle bodyFont({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Accent font: Playfair Display - For special moments
  static TextStyle accentFont({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🏗️ THEME BUILDER
/// ═══════════════════════════════════════════════════════════════════════════

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          surface: AppColors.lightSurface,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,

        // Typography
        textTheme: TextTheme(
          displayLarge: AppTypography.displayFont(
              fontSize: 32, color: AppColors.lightTextPrimary),
          displayMedium: AppTypography.displayFont(
              fontSize: 28, color: AppColors.lightTextPrimary),
          displaySmall: AppTypography.displayFont(
              fontSize: 24, color: AppColors.lightTextPrimary),
          headlineLarge: AppTypography.displayFont(
              fontSize: 22, color: AppColors.lightTextPrimary),
          headlineMedium: AppTypography.displayFont(
              fontSize: 20, color: AppColors.lightTextPrimary),
          headlineSmall: AppTypography.displayFont(
              fontSize: 18, color: AppColors.lightTextPrimary),
          titleLarge: AppTypography.bodyFont(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary),
          titleMedium: AppTypography.bodyFont(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary),
          titleSmall: AppTypography.bodyFont(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary),
          bodyLarge: AppTypography.bodyFont(
              fontSize: 16, color: AppColors.lightTextPrimary),
          bodyMedium: AppTypography.bodyFont(
              fontSize: 14, color: AppColors.lightTextPrimary),
          bodySmall: AppTypography.bodyFont(
              fontSize: 12, color: AppColors.lightTextSecondary),
          labelLarge: AppTypography.bodyFont(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary),
          labelMedium: AppTypography.bodyFont(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextSecondary),
          labelSmall: AppTypography.bodyFont(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextSecondary),
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.displayFont(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // Cards with organic shadows
        cardTheme: CardThemeData(
          color: AppColors.lightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: AppColors.lightShadow,
        ),

        // Bottom sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),

        // FAB with glow effect
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.tertiary,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        // Elevated buttons with organic shape
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AppColors.forestGlow,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: AppTypography.bodyFont(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text buttons
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.bodyFont(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Input decoration with organic feel
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSurface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: AppColors.secondary.withValues(alpha: 0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: AppColors.secondary.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: AppTypography.bodyFont(
            fontSize: 14,
            color: AppColors.lightTextSecondary,
          ),
        ),

        // Tabs
        tabBarTheme: TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.tertiary,
          labelStyle:
              AppTypography.bodyFont(fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTypography.bodyFont(fontSize: 14),
        ),

        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedColor: AppColors.primary.withValues(alpha: 0.15),
          labelStyle: AppTypography.bodyFont(fontSize: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Divider
        dividerTheme: DividerThemeData(
          color: AppColors.secondary.withValues(alpha: 0.2),
          thickness: 1,
        ),

        extensions: const [AppThemeExtension.light],
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          surface: AppColors.darkSurface,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,

        // Typography
        textTheme: TextTheme(
          displayLarge: AppTypography.displayFont(
              fontSize: 32, color: AppColors.darkTextPrimary),
          displayMedium: AppTypography.displayFont(
              fontSize: 28, color: AppColors.darkTextPrimary),
          displaySmall: AppTypography.displayFont(
              fontSize: 24, color: AppColors.darkTextPrimary),
          headlineLarge: AppTypography.displayFont(
              fontSize: 22, color: AppColors.darkTextPrimary),
          headlineMedium: AppTypography.displayFont(
              fontSize: 20, color: AppColors.darkTextPrimary),
          headlineSmall: AppTypography.displayFont(
              fontSize: 18, color: AppColors.darkTextPrimary),
          titleLarge: AppTypography.bodyFont(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary),
          titleMedium: AppTypography.bodyFont(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary),
          titleSmall: AppTypography.bodyFont(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary),
          bodyLarge: AppTypography.bodyFont(
              fontSize: 16, color: AppColors.darkTextPrimary),
          bodyMedium: AppTypography.bodyFont(
              fontSize: 14, color: AppColors.darkTextPrimary),
          bodySmall: AppTypography.bodyFont(
              fontSize: 12, color: AppColors.darkTextSecondary),
          labelLarge: AppTypography.bodyFont(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextPrimary),
          labelMedium: AppTypography.bodyFont(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkTextSecondary),
          labelSmall: AppTypography.bodyFont(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.darkTextSecondary),
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTypography.displayFont(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // Cards
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: AppColors.darkShadow,
        ),

        // Bottom sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),

        // FAB with mystic glow
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.tertiary,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        // Elevated buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AppColors.mysticGlow,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: AppTypography.bodyFont(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text buttons
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondary,
            textStyle: AppTypography.bodyFont(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkCard,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: AppColors.secondary.withValues(alpha: 0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: AppColors.secondary.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.secondary, width: 2),
          ),
          hintStyle: AppTypography.bodyFont(
            fontSize: 14,
            color: AppColors.darkTextSecondary,
          ),
        ),

        // Tabs
        tabBarTheme: TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppColors.tertiary,
          labelStyle:
              AppTypography.bodyFont(fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTypography.bodyFont(fontSize: 14),
        ),

        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.darkCard,
          selectedColor: AppColors.primary.withValues(alpha: 0.3),
          labelStyle: AppTypography.bodyFont(fontSize: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Divider
        dividerTheme: DividerThemeData(
          color: AppColors.secondary.withValues(alpha: 0.15),
          thickness: 1,
        ),

        extensions: const [AppThemeExtension.dark],
      );
}

/// ═══════════════════════════════════════════════════════════════════════════
/// 🎨 DECORATIVE WIDGETS HELPERS
/// ═══════════════════════════════════════════════════════════════════════════

class AppDecorations {
  /// Organic card decoration with soft shadow
  static BoxDecoration organicCard({
    required Color color,
    Color? shadowColor,
    double borderRadius = 20,
    double elevation = 8,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: shadowColor ?? AppColors.lightShadow,
          blurRadius: elevation * 2,
          offset: Offset(0, elevation / 2),
          spreadRadius: 0,
        ),
      ],
    );
  }

  /// Gradient header decoration
  static BoxDecoration gradientHeader({
    List<Color>? colors,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors ?? [AppColors.primary, const Color(0xFF3D7A62)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: borderRadius,
    );
  }

  /// Glowing container for special elements
  static BoxDecoration glowingContainer({
    required Color color,
    required Color glowColor,
    double borderRadius = 16,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: glowColor,
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );
  }

  /// Parchment-style task card
  static BoxDecoration parchmentCard({
    required Color background,
    required Color border,
    bool isDark = false,
  }) {
    return BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: isDark ? AppColors.darkShadow : AppColors.lightShadow,
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
