import 'package:flutter/material.dart';

/// Cinematic dark design tokens. This is the ONLY place raw brand values live —
/// swapping in a real corporate brand later is a single-file change.
class AppColors {
  AppColors._();

  // Canvas & surfaces
  static const canvas = Color(0xFF0B0B0F); // near-black page
  static const canvasAlt = Color(0xFF101015);
  static const surface = Color(0xFF16161C); // cards
  static const surfaceRaised = Color(0xFF1F1F27); // raised / inputs
  static const surfaceHover = Color(0xFF26262F);
  static const line = Color(0xFF2A2A33);
  static const lineStrong = Color(0xFF3A3A45);

  // Accent (bold red)
  static const accent = Color(0xFFE50914);
  static const accentSoft = Color(0xFFF6121D);
  static const accentDim = Color(0xFF8E1116);

  // Text
  static const textHi = Color(0xFFFFFFFF);
  static const textMid = Color(0xFFD9D9DE);
  static const textLo = Color(0xFFB3B3B3);
  static const textFaint = Color(0xFF7A7A85);

  // Semantic
  static const success = Color(0xFF2DD467);
  static const warn = Color(0xFFF5A524);
  static const danger = Color(0xFFE50914);
  static const info = Color(0xFF4DA3FF);

  /// Category accents used for poster gradients (deterministic by index).
  static const palette = <Color>[
    Color(0xFFE50914),
    Color(0xFF7B2FF7),
    Color(0xFF0FB5BA),
    Color(0xFFF5A524),
    Color(0xFF2DD467),
    Color(0xFF4DA3FF),
  ];

  static Color categoryColor(int index) => palette[index % palette.length];
}

class AppSpacing {
  AppSpacing._();
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 40.0;
  static const xxl = 64.0;
  static const maxContent = 1240.0;
}

class AppRadii {
  AppRadii._();
  static const sm = 6.0;
  static const md = 10.0;
  static const lg = 16.0;
  static const poster = 8.0;
}
