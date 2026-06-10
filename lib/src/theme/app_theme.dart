import 'package:flutter/material.dart';

import 'tokens.dart';

/// Builds the cinematic dark [ThemeData]. Kept deliberately lean — most
/// component styling lives in the design-system widgets so the theme stays
/// version-robust across Flutter releases.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    const scheme = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: Colors.white,
      secondary: AppColors.accentSoft,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textHi,
      error: AppColors.danger,
      onError: Colors.white,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      canvasColor: AppColors.canvas,
      dividerColor: AppColors.line,
      splashFactory: InkRipple.splashFactory,
      textTheme: _text(base.textTheme),
      iconTheme: const IconThemeData(color: AppColors.textLo),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.textHi,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.surfaceRaised,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textHi,
          side: const BorderSide(color: AppColors.lineStrong),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.textMid),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceRaised,
        hintStyle: const TextStyle(color: AppColors.textFaint),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.line),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          border: Border.all(color: AppColors.line),
        ),
        textStyle: const TextStyle(color: AppColors.textHi, fontSize: 12),
      ),
    );
  }

  static TextTheme _text(TextTheme base) {
    TextStyle? hi(TextStyle? s, {FontWeight? w, double? ls}) =>
        s?.copyWith(color: AppColors.textHi, fontWeight: w, letterSpacing: ls);
    return base.copyWith(
      displayLarge: hi(base.displayLarge, w: FontWeight.w800, ls: -1.5),
      displayMedium: hi(base.displayMedium, w: FontWeight.w800, ls: -1.2),
      displaySmall: hi(base.displaySmall, w: FontWeight.w800, ls: -1.0),
      headlineMedium: hi(base.headlineMedium, w: FontWeight.w700, ls: -0.6),
      headlineSmall: hi(base.headlineSmall, w: FontWeight.w700, ls: -0.4),
      titleLarge: hi(base.titleLarge, w: FontWeight.w700, ls: -0.2),
      titleMedium: hi(base.titleMedium, w: FontWeight.w600),
      bodyLarge: base.bodyLarge?.copyWith(color: AppColors.textMid, height: 1.55),
      bodyMedium: base.bodyMedium?.copyWith(color: AppColors.textLo, height: 1.55),
      labelLarge: hi(base.labelLarge, w: FontWeight.w600),
    );
  }
}
