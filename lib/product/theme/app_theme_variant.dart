import 'package:flutter/material.dart';

/// Uygulama tema renk paletleri.
/// Her variant dark + light ColorScheme icerir.
enum AppThemeVariant {
  purple(
    key: 'purple',
    localeKey: 'theme.purple',
    seedColor: Color(0xFF7C4DFF),
    previewColor: Color(0xFF7C4DFF),
  ),
  blue(
    key: 'blue',
    localeKey: 'theme.blue',
    seedColor: Color(0xFF2196F3),
    previewColor: Color(0xFF2196F3),
  ),
  green(
    key: 'green',
    localeKey: 'theme.green',
    seedColor: Color(0xFF4CAF50),
    previewColor: Color(0xFF4CAF50),
  ),
  orange(
    key: 'orange',
    localeKey: 'theme.orange',
    seedColor: Color(0xFFFF9800),
    previewColor: Color(0xFFFF9800),
  ),
  red(
    key: 'red',
    localeKey: 'theme.red',
    seedColor: Color(0xFFE91E63),
    previewColor: Color(0xFFE91E63),
  ),
  black(
    key: 'black',
    localeKey: 'theme.black',
    seedColor: Color(0xFF263238),
    previewColor: Color(0xFF37474F),
  );

  const AppThemeVariant({
    required this.key,
    required this.localeKey,
    required this.seedColor,
    required this.previewColor,
  });

  final String key;
  final String localeKey;
  final Color seedColor;
  final Color previewColor;

  ColorScheme get darkColorScheme => ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      );

  ColorScheme get lightColorScheme => ColorScheme.fromSeed(
        seedColor: seedColor,
      );

  static AppThemeVariant fromKey(String key) =>
      AppThemeVariant.values.firstWhere(
        (v) => v.key == key,
        orElse: () => AppThemeVariant.black,
      );
}
