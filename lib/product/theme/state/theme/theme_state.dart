import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/product/theme/app_theme_variant.dart';

class ThemeState {
  const ThemeState({required this.variant, required this.themeMode});

  final AppThemeVariant variant;
  final ThemeMode themeMode;

  ThemeState copyWith({AppThemeVariant? variant, ThemeMode? themeMode}) {
    return ThemeState(
      variant: variant ?? this.variant,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
