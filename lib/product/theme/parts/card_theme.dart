part of '../theme.dart';

CardThemeData _buildCardTheme(ColorScheme cs) => CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cs.surfaceContainerLow,
      shadowColor: cs.shadow.withValues(alpha: 0.15),
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
