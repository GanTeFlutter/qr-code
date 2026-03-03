import 'package:flutter/material.dart';

/// Semantik renkler icin ThemeExtension.
/// Tema variant'iyla degismez, sabit kalir.
/// Dark/light farki olmadan ayni degeri dondurur.
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.scoreGold,
    required this.scoreRed,
    required this.scoreGreen,
    required this.scoreBlue,
    required this.scorePink,
    required this.toggleActive,
    required this.toggleInactive,
    required this.pureWhite,
    required this.pureBlack,
    required this.grey,
    required this.greyLight,
    required this.greyDark,
    required this.transparent,
  });

  // ── Skor renkleri ────────────────────────────────────────
  final Color scoreGold;
  final Color scoreRed;
  final Color scoreGreen;
  final Color scoreBlue;
  final Color scorePink;

  // ── Toggle renkleri ──────────────────────────────────────
  final Color toggleActive;
  final Color toggleInactive;

  // ── Sabit renkler ────────────────────────────────────────
  final Color pureWhite;
  final Color pureBlack;
  final Color grey;
  final Color greyLight;
  final Color greyDark;
  final Color transparent;

  static const appColors = AppThemeColors(
    scoreGold: Color(0xFFFFD700),
    scoreRed: Color(0xFFFF4757),
    scoreGreen: Color(0xFF2ED573),
    scoreBlue: Color(0xFF1E90FF),
    scorePink: Color(0xFFFF6B81),
    toggleActive: Color(0xFF2ED573),
    toggleInactive: Color(0xFFEF5350),
    pureWhite: Colors.white,
    pureBlack: Colors.black,
    grey: Color(0xFF9E9E9E),
    greyLight: Color(0xFFE0E0E0),
    greyDark: Color(0xFF616161),
    transparent: Colors.transparent,
  );

  @override
  AppThemeColors copyWith({
    Color? scoreGold,
    Color? scoreRed,
    Color? scoreGreen,
    Color? scoreBlue,
    Color? scorePink,
    Color? toggleActive,
    Color? toggleInactive,
    Color? pureWhite,
    Color? pureBlack,
    Color? grey,
    Color? greyLight,
    Color? greyDark,
    Color? transparent,
  }) => AppThemeColors(
    scoreGold: scoreGold ?? this.scoreGold,
    scoreRed: scoreRed ?? this.scoreRed,
    scoreGreen: scoreGreen ?? this.scoreGreen,
    scoreBlue: scoreBlue ?? this.scoreBlue,
    scorePink: scorePink ?? this.scorePink,
    toggleActive: toggleActive ?? this.toggleActive,
    toggleInactive: toggleInactive ?? this.toggleInactive,
    pureWhite: pureWhite ?? this.pureWhite,
    pureBlack: pureBlack ?? this.pureBlack,
    grey: grey ?? this.grey,
    greyLight: greyLight ?? this.greyLight,
    greyDark: greyDark ?? this.greyDark,
    transparent: transparent ?? this.transparent,
  );

  @override
  AppThemeColors lerp(covariant AppThemeColors? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      scoreGold: Color.lerp(scoreGold, other.scoreGold, t)!,
      scoreRed: Color.lerp(scoreRed, other.scoreRed, t)!,
      scoreGreen: Color.lerp(scoreGreen, other.scoreGreen, t)!,
      scoreBlue: Color.lerp(scoreBlue, other.scoreBlue, t)!,
      scorePink: Color.lerp(scorePink, other.scorePink, t)!,
      toggleActive: Color.lerp(toggleActive, other.toggleActive, t)!,
      toggleInactive: Color.lerp(toggleInactive, other.toggleInactive, t)!,
      pureWhite: Color.lerp(pureWhite, other.pureWhite, t)!,
      pureBlack: Color.lerp(pureBlack, other.pureBlack, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      greyLight: Color.lerp(greyLight, other.greyLight, t)!,
      greyDark: Color.lerp(greyDark, other.greyDark, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
    );
  }
}
